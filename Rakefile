#!/usr/bin/env rake

require "rubygems"
require "bundler/setup"
require "appraisal"
require "rspec/core/rake_task"

require "bundler/gem_tasks"

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  #t.rspec_path = 'bin/rspec'
  t.rspec_opts = %w[--color]
end

task :default => :spec
