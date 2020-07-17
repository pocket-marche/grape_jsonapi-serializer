
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape_jsonapi/serializer/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape_jsonapi-serializer'
  spec.version       = GrapeJsonapi::Serializer::VERSION
  spec.authors       = ['Norifumi Homma']
  spec.email         = ['norifumi.homma@gmail.com']

  spec.summary       = 'Use jsonapi-serializer in grape'
  spec.description   = 'Provides a Formatter for the Grape API DSL to emit objects serialized with jsonapi-serializer.'
  spec.homepage      = 'https://github.com/pocket-marche/grape_jsonapi-serializer'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'grape'
  spec.add_dependency 'jsonapi-serializer'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
