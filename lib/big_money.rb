# coding: utf-8
dir = File.dirname(__FILE__)
$LOAD_PATH << dir unless $LOAD_PATH.include?(dir)

require 'big_money/currency'
require 'big_money/currency/iso4217'
require 'big_money/big_money'
require 'big_money/ext' # TODO: Optional?

