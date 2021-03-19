require './lib/docker.rb'

Gem::Specification.new do |s|
  s.name        = 'mina-docker'
  s.version     = Mina::Docker::VERSION
  s.date        = '2020-11-22'
  s.summary     = 'add docker support for mina.'
  s.description = 'add docker support for mina.'
  s.authors     = ['flydragon']
  s.email       = 'flydragon@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/flydrago/mina-docker'
  s.license     = 'MIT'
  s.require_paths = ['lib']

  s.add_runtime_dependency 'mina', '>= 1.0.2'
end
