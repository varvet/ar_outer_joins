# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ar_outer_joins/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jonas Nicklas"]
  gem.email         = ["jonas.nicklas@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ar_outer_joins"
  gem.require_paths = ["lib"]
  gem.version       = ArOuterJoins::VERSION

  gem.add_dependency "activerecord", "~>3.0"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "pry"
end
