require 'rake'
require 'rake/tasklib'
require 'rubygems/xcodeproj_generator/project'

module Rubygems
  module XcodeprojGenerator
    class RakeTask < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)

      def self.last_description
        if ::Rake.application.respond_to?(:last_description)
          ::Rake.application.last_description
        else
          ::Rake.application.last_comment
        end
      end

      def initialize(name = :generate_xcode_project)
        unless self.class.last_description
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
