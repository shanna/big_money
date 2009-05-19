# coding: utf-8
require 'singleton'

class BigMoney
  module Currencies
    # Short form BigMoney::Currency.find(code) to save some typing.
    #
    # ==== Examples
    #
    #   BigMoney.currency(:usd) #=> BigMoney::Currency.find(:usd)
    #
    # ==== Parameters
    # code<#to_s>:: An upper or lowercase string or symbol of the ISO-4217 currency code.
    #
    # ==== Returns
    # BigMoney::Currency
    def currency(code)
      Currency.find(code)
    end
  end # Currencies
  extend Currencies

  # Currency singleton objects.
  #
  # By default ISO4217 currency codes are known and registered with the factory. You'll need to sublcass Currency in
  # order to use non ISO4217 currencies.
  #
  #   class WOW < BigMoney::Currency
  #     self.name   = 'World of Warcraft Gold'
  #     self.code   = 'WOW'
  #     self.offset = 4
  #   end
  #
  #   bm = BigMoney.new(12.5020, :wow) # Would throw an UnknownCurrency error without the subclass.
  #   bm.to_s #=> 'WOW 12.5000' # 12 gold, 50 silver, 20 copper
  #
  # Currency singletons are comparable against itself, an upper or lowercase string or symbol of the currency code.
  #
  #  gold = WOW.instance
  #  gold == :wow  #=> true
  #  gold == 'wow' #=> true
  class Currency
    include Comparable
    include Singleton

    # Compare against another currency object, an upper or lowercase string or symbol of the currecy code.
    def <=>(value)
      code.to_s <=> value.to_s.upcase
    end

    # English currency name.
    def name
      self.class.name
    end

    # ISO 4217 3 letter currency code.
    def code
      self.class.code
    end

    # Number of decimal places to display by default.
    def offset
      self.class.offset
    end

    # Currency code.
    def to_s
      code.to_s
    end

    class << self
      attr_accessor :name, :code, :offset

      @@currencies = []
      def inherited(currency) #:nodoc:
        super
        @@currencies << currency
      end

      # All currencies. By default all current ISO4217 currencies.
      def all
        @@currencies.uniq
      end

      # Find a currency instance from an upper or lowercase string or symbol of the currency code.
      def find(currency)
        klass = all.find{|c| c.code == currency.to_s.upcase}
        raise ArgumentError.new("+currency+ '#{currency}' does not exist.") if klass.nil?
        klass.instance
      end
    end
  end # Currency

end # Money
