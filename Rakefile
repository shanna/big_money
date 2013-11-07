# encoding: utf-8
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'yard'
YARD::Rake::YardocTask.new do |yard|
  yard.files = Dir["lib/**/*.rb"]
end

namespace :currency do
  desc 'Create ISO 4217 currency classes from wikipedia ISO 4217 table.'
  task :iso4217 do
    dirname = File.dirname(__FILE__)
    gen     = File.join(dirname, 'rakelib', %w{iso4217.rb})
    lib     = File.expand_path(File.join(dirname, %w{lib big_money currency iso4217.rb}))
    require gen
    modules = BigMoney::Task::ISO4217.get
    File.open(lib, File::CREAT | File::TRUNC | File::WRONLY) do |f|
      f.write modules
    end
  end
end

task :default => :test

