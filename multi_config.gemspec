# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'multi_config'
  spec.version       = MultiConfig::VERSION
  spec.authors       = ['PharaohKJ']
  spec.email         = ['kato@phalanxware.com']

  spec.summary       = 'Support get valued for configure from multi source.'
  spec.description   = 'Support get valued for configure from multi source.'
  spec.homepage      = 'https://github.com/PharaohKJ/multi_config'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
