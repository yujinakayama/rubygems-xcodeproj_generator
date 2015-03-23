[![Build Status](https://travis-ci.org/yujinakayama/rubygems-xcodeproj_generator.svg?branch=master&style=flat)](https://travis-ci.org/yujinakayama/rubygems-xcodeproj_generator)
[![Coverage Status](http://img.shields.io/coveralls/yujinakayama/rubygems-xcodeproj_generator/master.svg?style=flat)](https://coveralls.io/r/yujinakayama/rubygems-xcodeproj_generator)

# Rubygems::XcodeprojGenerator

Provides a Rake task for generating an Xcode project for C extension development.

Within the generated Xcode project:

* Code completion is enabled, including Ruby internal functions and macros.
* You can build the extension by running **⌘B**, though this is just for checking while development and not for production release.

## Basic Usage

Add the following development dependencies to your extension's Gemfile or gemspec:

```ruby
gem 'rake-compiler'
gem 'rubygems-xcodeproj_generator'
```

And execute:

```bash
$ bundle install
```

Then add the following code to your Rakefile:

```ruby
require 'rake/extensiontask'
require 'rubygems/xcodeproj_generator/rake_task'

Rake::ExtensionTask.new('your-comple-task-name')

Rubygems::XcodeprojGenerator::RakeTask.new do |project|
  project.name = 'your-xcode-project-name'
  project.build_command = 'bundle exec rake your-comple-task-name'
end
```

And run:

```bash
$ bundle exec rake generate_xcode_project
```

## License

Copyright (c) 2015 Yuji Nakayama

See the [LICENSE.txt](LICENSE.txt) for details.
