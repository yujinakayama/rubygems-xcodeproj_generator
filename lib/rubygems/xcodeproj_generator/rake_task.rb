require 'rake'
require 'rake/tasklib'
require 'rubygems/xcodeproj_generator/project'

module Rubygems
  module XcodeprojGenerator
    class RakeTask < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)

      def initialize(name = :generate_xcode_project)
        unless ::Rake.application.last_comment
          desc 'Generate an Xcode project for C extension development'
        end

        task(name) do
          project = Project.new

          yield project

          project.name ||= File.basename(Dir.pwd)
          project.save

          puts "Xcode project has been generated to #{project.path}."
        end
      end
    end
  end
end
