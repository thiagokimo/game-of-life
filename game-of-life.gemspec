# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'game-of-life/version'

Gem::Specification.new do |gem|
  gem.name          = "game-of-life"
  gem.version       = GameOfLife::VERSION
  gem.authors       = ["Thiago Rocha"]
  gem.email         = ["kimo@kimo.io"]
  gem.description   = %q{The Game of Life}
  gem.summary       = %q{A gem that shows random matches of Conway's Game of Life }
  gem.homepage      = "http://thiagokimo.github.io/game-of-life"

  gem.license = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rake'

  gem.add_dependency 'gosu'
end
