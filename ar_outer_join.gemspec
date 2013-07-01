# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ar_outer_joins/version', __FILE__)

Gem::Specification.new do |spec|
  spec.authors       = ["Jonas Nicklas", "Elabs AB", "Michael Nowak"]
  spec.email         = ["jonas.nicklas@gmail.com", "dev@elabs.se", "thexsystem@gmail.com"]
  spec.description   = %q{Adds the missing outer_joins method to ActiveRecord}
  spec.summary       = %q{outer_joins for ActiveRecord}
  spec.homepage      = "http://github.com/mmichaa/ar_outer_joins"
  spec.license       = "MIT"

  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.name          = "ar_outer_joins"
  spec.require_paths = ["lib"]
  spec.version       = ArOuterJoins::VERSION

  spec.add_dependency "activerecord", ">=3.2"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
end
