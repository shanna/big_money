require 'bundler'
Bundler.setup(:development)
require 'test/unit'

begin
  require 'shoulda'
rescue LoadError
  warn 'Shoulda is required for testing. Use gem bundle to install development gems.'
  exit 1
end

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$:.unshift File.join(root, 'lib'), File.dirname(__FILE__)
require 'big_money'

class Test::Unit::TestCase
end
