# coding: utf-8

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'big_money'
    gem.summary = %q{BigDecimal backed amount of money in a particular currency.}
    gem.email = ['mroch@cmu.edu', 'shane.hanna@gmail.com']
    gem.homepage = 'http://github.com/mroch/big_money'
    gem.authors = ['Marshall Roch', 'Shane Hanna']
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "big_money #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :currency do
  desc 'Create ISO 4217 currency classes from wikipedia ISO 4217 table.'
  task :iso4217 do
    dirname = File.dirname(__FILE__)
    gen     = File.join(dirname, %w{iso4217.rb})
    lib     = File.expand_path(File.join(dirname, %w{.. lib big_money currency iso4217.rb}))
    require gen
    modules = BigMoney::Task::ISO4217.get
    File.open(lib, File::CREAT | File::TRUNC | File::WRONLY) do |f|
      f.write modules
    end
  end
end

task :default => :test

