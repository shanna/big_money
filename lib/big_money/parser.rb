# coding: utf-8
# require 'big_money'

class BigMoney
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
    # money<BigMoney, #to_s>::
    #   The object to parse as money.
    #
    # currency<BigMoney::Currency, #to_s>::
    #   The default currency to use if a currency can't be found.
    #
    # ==== Returns
    # BigMoney
    def parse(money, currency = default_currency)
      case money
        when BigMoney                   then money
        when BigDecimal, Integer, Float then new(money, currency)
        else
          match    = REGEXP.match(money.to_s) || return
          currency = [match[1], match[4], currency].find{|c| Currency.find(c) rescue nil} || return

          # TODO: Currency should have a .delimiter method I reckon that returns the major/minor delimiter.
          # For now '.' will do and everything else will be stripped.
          money = [match[2], match[3].gsub(/[^0-9.E]/i, '')].join
          new(money, currency)
      end
    end
  end # Parser

  extend Parser
end # BigMoney
