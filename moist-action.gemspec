
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moist/action/version'

Gem::Specification.new do |spec|
  spec.name          = 'moist-action'
  spec.version       = Moist::Action::VERSION
  spec.authors       = ['Tema Bolshakov']
  spec.email         = ['either.free@gmail.com']

  spec.summary       = 'Better controller actions'
  spec.description   = 'Better controller actions'
  spec.homepage      = 'https://github.com/moist-rb/action'

  spec.files         = Dir['lib/**/*']
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '1.16.1'
  spec.add_development_dependency 'fear-rspec', '0.2.0'
  spec.add_development_dependency 'rake', '12.3.0'
  spec.add_development_dependency 'rspec', '3.7.0'
  spec.add_development_dependency 'rubocop', '0.53.0'

  spec.add_runtime_dependency 'dry-validation', '0.11.1'
  spec.add_runtime_dependency 'fear', '0.7.0'
end
