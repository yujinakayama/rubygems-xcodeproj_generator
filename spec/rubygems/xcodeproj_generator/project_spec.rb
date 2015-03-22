require 'rubygems/xcodeproj_generator/project'

module Rubygems::XcodeprojGenerator
  RSpec.describe Project do
    subject(:project) { Project.new('foo') }
  end
end
