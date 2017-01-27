require 'rake'
require 'rake/tasklib'
require 'rubygems/xcodeproj_generator/project'

module Rubygems
  module XcodeprojGenerator
    class RakeTask < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)

      def initialize(name = :generate_xcode_project)
        last_message = ::Rake::VERSION.to_f >= 12.0 ? ::Rake.application.last_description : ::Rake.application.last_comment
        unless last_message
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
