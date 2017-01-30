# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygems/xcodeproj_generator/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubygems-xcodeproj_generator'
  spec.version       = Rubygems::XcodeprojGenerator::Version.to_s
  spec.authors       = ['Yuji Nakayama']
  spec.email         = ['nkymyj@gmail.com']

  spec.summary       = 'Provides a Rake task for generating an Xcode project ' \
                       'for C extension development.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/yujinakayama/rubygems-xcodeproj_generator'
  spec.license       = 'MIT'

  spec.files         =
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'xcodeproj', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 1.7'
end
