# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastly/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastly'
  spec.version       = Fastly::VERSION
  spec.authors       = ['Josh Lane']
  spec.email         = ['jlane@fastly.com']

  spec.summary       = 'Client library for the Fastly acceleration system'
  spec.description   = 'Client library for the Fastly acceleration system'
  spec.homepage      = 'https://github.com/fastly/fastly-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'cistern', '~> 2.4', '> 2.4.0'
  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware', '~> 0.9'
  spec.add_dependency 'faraday-cookie_jar', '~> 0.0'
  spec.add_dependency 'faraday-detailed_logger', '~> 1.0'
end
