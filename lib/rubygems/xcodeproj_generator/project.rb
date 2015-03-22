require 'xcodeproj'
require 'rubygems/xcodeproj_generator/rbenv'
require 'rubygems/xcodeproj_generator/xcode'

module Rubygems
  module XcodeprojGenerator
    class Project
      attr_accessor :name, :build_command

      def initialize(name = nil)
        @name = name
      end

      def path
        project.path
      end

      def save
        configure_header_search_paths
        configure_groups
        configure_build_phase
        project.save
      end

      private

      def project
        @project ||= Xcodeproj::Project.new("#{name}.xcodeproj")
      end

      def target
        # We don't use the PBXLegacyTarget class (a.k.a External Build System) since it cannot have
        # build settings and the Xcode's code completion cannot be enabled.
        @target ||= project.new_target(:static_library, name, :osx).tap do |target|
          target.product_reference = nil
          target.build_phases.clear
          project.targets << target
        end
      end

      def configure_header_search_paths
        target.build_configurations.each do |config|
          config.build_settings['HEADER_SEARCH_PATHS'] = ruby_header_paths.join(' ')
        end
      end

      def configure_build_phase
        return unless build_command

        build_phase = target.new_shell_script_build_phase

        build_phase.shell_path = '/usr/bin/ruby'

        # Xcode automatically sets a number of environment variables from the Xcode project's build
        # settings and clang refers them. However we configure the build settings only for code
        # completion in Xcode and they may be wrong for the real build. So we reset the Xcode's
        # environments variables and restore the current variables before invoking the external
        # build command.
        build_phase.shell_script = <<-END.gsub(/^\s+\|/, '')
          |ENV.clear
          |ENV.update(#{ENV.to_hash.inspect})
          |system(#{build_command.inspect})
        END
      end

      def configure_groups
        project.main_group.clear

        group = project.new_group('Sources')

        file_references = Dir['ext/**/*.{h,c}'].map do |path|
          group.new_reference(path, :project)
        end

        # Xcode's code completion is enabled only in files that are compiled in the active target.
        target.add_file_references(file_references)

        group.sort
      end

      def ruby_header_paths
        if rbenv.available?
          rbenv.ruby_header_paths
        else
          xcode.ruby_header_paths
        end
      end

      def rbenv
        @rbenv ||= Rbenv.new
      end

      def xcode
        @xcode ||= Xcode.new
      end
    end
  end
end
