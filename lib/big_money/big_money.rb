# coding: utf-8
require 'bigdecimal'
require 'big_money/currency'

# == Synopsis
#
#   bm = BigMoney.new('3.99')
#   bm.amount           #=> BigDecimal.new('3.99')
#   bm.currency         #=> BigMoney::Currency::USD.instance
#   bm.to_s             #=> '3.99'
#   bm.to_s('$.2f')     #=> '$3.99'
#   bm.to_s('$%.2f %s') #=> '$3.99 USD'
class BigMoney
  attr_reader :amount, :currency

  # USD.
  @@default_currency = Currency::USD.instance

  # The default currency.
  #
  # ==== Returns
  # BigMoney::Currency or nil
  def self.default_currency
    @@default_currency
  end

  # The default currency.
  #
  # ==== Parameters
  # currency<BigMoney::Currency, #to_s>:: ISO-4217 3 letter currency code.
  #
  # ==== Returns
  # BigMoney::Currency
  def self.default_currency=(currency)
    @@default_currency = Currency.find(currency)
  end

  # Create a BigMoney instance.
  #
  # ==== Parameters
  # amount<BigDecimal, #to_s>:: Amount.
  # currency<BigMoney::Currency, #to_s>:: Optional ISO-4217 3 letter currency code.
  #
  # ==== Notes
  # Uses the default currency if none is passed.
  #
  # ==== Returns
  # BigMoney
  def initialize(amount, currency = nil)
    raise ArgumentError.new("+amount+ must be BigDecimal or respond to #to_s, but was '#{amount.class}'.") \
      unless amount.kind_of?(BigDecimal) || amount.respond_to?(:to_s)

    @amount   = amount.class == BigDecimal ? amount : BigDecimal.new(amount.to_s)
    @currency = self.class.currency(currency || self.class.default_currency)
  end

  def eql?(money)
    assert_kind money
    currency == money.currency && amount == money.amount
  end

  def ==(money)
    eql?(money)
  end

  def <=>(money)
    assert_cmp money
    amount <=> money.amount
  end

  def -@
    self.class.new(-amount, currency)
  end

  def +(val)
    op(:+, val)
  end

  def -(val)
    op(:-, val)
  end

  def *(val)
    op(:*, val)
  end

  def /(val)
    op(:/, val)
  end

  def to_s(format = nil)
    format ||= "%.#{currency.offset}f"
    format.sub(/%s/, currency.code) % amount
  end

  def to_i
    amount.to_i
  end

  def to_f
    amount.to_f
  end

  protected
    def assert_kind(money, called = caller) #:nodoc:
      raise ArgumentError.new("+money+ must be kind of BigMoney, but got '#{money.class}'.", called) \
        unless money.kind_of?(BigMoney)
    end

    def assert_cmp(money, called = caller) #:nodoc:
      assert_kind money, called
      raise TypeError.new("Currency mistmatch, cannot compare '#{to_s}' to '#{money.to_s}'.", called) \
        unless currency == money.currency
    end

  private
    def op(s, val) #:nodoc:
      if val.class == BigMoney
        assert_cmp val, caller
        self.class.new(amount.send(s, val.amount), currency)
      else
        self.class.new(amount.send(s, val), currency)
      end
    end
end
