Gem::Specification.new do |s|
  s.name        = 'mina-docker'
  s.version     = '0.0.1'
  s.date        = '2020-11-22'
  s.summary     = 'dd docker support for mina.'
  s.description = 'add docker support for mina.'
  s.authors     = ['flydragon']
  s.email       = 'flydragon@gmail.com'
  s.files       = ['lib/docker.rb']
  s.homepage    = 'https://rubygems.org/gems/mina-docker'
  s.license     = 'MIT'
  s.require_paths = ['lib']

  s.add_runtime_dependency 'mina', '>= 1.0.2'
end