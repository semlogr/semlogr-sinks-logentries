lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'semlogr/sinks/logentries/version'

Gem::Specification.new do |spec|
  spec.name          = 'semlogr-sinks-logentries'
  spec.version       = Semlogr::Sinks::Logentries::VERSION
  spec.authors       = ['Stefan Sedich']
  spec.email         = ['stefan.sedich@gmail.com']

  spec.summary       = 'A semlogr sink for logging to logentries.'
  spec.description   = 'A semlogr sink for logging to logentries.'
  spec.homepage      = 'https://github.com/semlogr/semlogr-sinks-logentries'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'semlogr', '~> 0.3.2'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.58.0'
end
