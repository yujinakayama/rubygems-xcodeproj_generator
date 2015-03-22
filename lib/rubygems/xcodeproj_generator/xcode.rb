require 'rubygems/xcodeproj_generator/abstract_ruby_header_provider'

module Rubygems
  module XcodeprojGenerator
    class Xcode < AbstractRubyHeaderProvider
      DEFAULT_ROOT_PATH = '/Applications/Xcode.app'
      OSX_SDKS_PATH = 'Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs'
      RUBY_INCLUDE_PATH_PATTERN =
        'System/Library/Frameworks/Ruby.framework/Versions/*/usr/include/*'

      def initialize(root_path = nil)
        root_path ||= DEFAULT_ROOT_PATH
        super(root_path)
      end

      private

      def base_ruby_header_path
        return nil unless latest_osx_sdk
        find_path(root_path, OSX_SDKS_PATH, latest_osx_sdk, RUBY_INCLUDE_PATH_PATTERN)
      end

      def latest_osx_sdk
        osx_sdks.sort_by do |sdk|
          version = sdk.match(/\d+\.\d+/).to_s
          Gem::Version.new(version)
        end.last
      end

      def osx_sdks
        return [] unless available?

        sdks_dir = File.join(root_path, OSX_SDKS_PATH)
        return [] unless Dir.exist?(sdks_dir)

        Dir.chdir(sdks_dir) do
          Dir['*']
        end
      end
    end
  end
end
