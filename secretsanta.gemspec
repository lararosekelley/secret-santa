# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secretsanta/version'

Gem::Specification.new do |spec|
  spec.name          = 'secretsanta'
  spec.version       = SecretSanta::VERSION
  spec.authors       = ['Ty-Lucas Kelley']
  spec.email         = ['tylucaskelley@gmail.com']

  spec.summary       = 'Start a gift exchange from the command line'
  spec.homepage      = 'https://github.com/tylucaskelley/secret-santa'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = ['secretsanta']
  spec.require_paths = ['lib']

  spec.add_dependency 'dotenv'
  spec.add_dependency 'twilio-ruby'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
end
