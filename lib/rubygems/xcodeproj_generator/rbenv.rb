require 'rubygems/xcodeproj_generator/abstract_ruby_header_provider'

module Rubygems
  module XcodeprojGenerator
    class Rbenv < AbstractRubyHeaderProvider
      DEFAULT_ROOT_PATH = '~/.rbenv'.freeze
      VERSIONS_PATH = 'versions'.freeze

      def initialize(root_path = nil)
        root_path ||= ENV['RBENV_ROOT'] || DEFAULT_ROOT_PATH
        super(root_path)
      end

      private

      def base_ruby_header_path
        return nil unless latest_cruby_version
        find_path(root_path, VERSIONS_PATH, latest_cruby_version, 'include/ruby-*')
      end

      def latest_cruby_version
        cruby_versions.sort_by { |version| Gem::Version.new(version) }.last
      end

      def cruby_versions
        versions.select { |version| version.match(/\A\d+\.\d+\.\d+/) }
      end

      def versions
        return [] unless available?

        versions_dir = File.join(root_path, VERSIONS_PATH)

        Dir.chdir(versions_dir) do
          Dir['*']
        end
      end
    end
  end
end
