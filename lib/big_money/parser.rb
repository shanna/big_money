# encoding: utf-8
require 'big_money' # Make it possible to just require 'big_money/parser'.

class BigMoney
  # Fuzzy string parsing.
  #
  # Supports scientific notation for amounts and ISO-4217 currency symbols.
  #
  # == Synopsis
  #
  #   require 'big_money'
  #   require 'big_money/parser' # This module/mixin.
  #
  #   BigMoney.parse('JPY ¥2500')   #=> BigMoney.new('2500', :jpy)
  #   BigMoney.parse('JPY2500')     #=> BigMoney.new('2500', :jpy)
  #   BigMoney.parse('2500JPY')     #=> BigMoney.new('2500', :jpy)
  #   BigMoney.parse('¥2500JPY')    #=> BigMoney.new('2500', :jpy)
  #   BigMoney.parse('¥2500')       #=> BigMoney.new('2500', :xxx)
  #
  # == Currency
  #
  # Due to the nature of string parsing it's possible t
  module Parser
    REGEXP = %r{
      (?:^|\b)
      ((?:[a-zA-Z]{3})?)\s*             # ISO4217 Currency code.
      [^\d+-]?                          # Currency symbol.
      ([-+]?)                           # +-
      [^\d+-]?                          # Currency symbol.
      \s*(
        (?:(?:\d(?:\d+|[., ]?)*\d)|\d)  # Digits and ., or spaces.
        (?:[eE][-+]?\d+)?               # Exponents.
      )\s*
      ((?:[a-zA-Z]{3})?)                # ISO4217 Currency code.
      (?:$|\b)
    }x

    # Fuzzy parsing.
    #
    # ==== Parameters
    # money<.to_s>:: The object to parse as money.
    #
    # ==== Currency
    # ISO-4217 BigMoney::Currency::XXX aka 'No currency' will be used if a currency cannot be parsed along with the
    # amount. If you know the currency and just need the amount XXX is always exchanged 1:1 with any currency:
    #
    # money = BigMoney.parse('¥2500') #=> BigMoney.new('2500', :xxx)
    # money.exchange(:jpy)            #=> BigMoney.new('2500', :jpy)
    #
    # ==== Returns
    # BigMoney or nil
    def parse(money)
      raise TypeError.new("Can't convert +money+ #{money.class} into String.") unless money.respond_to?(:to_s)

      match    = REGEXP.match(money.to_s) || return
      currency = [match[1], match[4]].find{|c| Currency.find(c)} || Currency::XXX

      # TODO: Currency should have a .delimiter method I reckon that returns the major/minor delimiter.
      # For now '.' will do and everything else will be stripped.
      money = [match[2], match[3].gsub(/[^0-9.Ee]/, '')].join
      new(money, currency)
    end
  end # Parser

  extend Parser
end # BigMoney
