module Rubygems
  module XcodeprojGenerator
    class AbstractRubyHeaderProvider
      attr_reader :root_path

      def initialize(root_path)
        @root_path = File.expand_path(root_path)
      end

      def available?
        Dir.exist?(root_path)
      end

      def ruby_header_paths
        [base_ruby_header_path, platform_ruby_header_path].compact
      end

      private

      def base_ruby_header_path
        raise NotImplementedError
      end

      def platform_ruby_header_path
        return nil unless base_ruby_header_path
        find_path(base_ruby_header_path, '*darwin*')
      end

      def find_path(*parts)
        pattern = File.join(*parts)
        Dir[pattern].first
      end
    end
  end
end
