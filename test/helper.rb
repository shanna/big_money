$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'test'))
require 'bundler/setup'
require 'minitest/autorun'
require 'big_money'

