# encoding: utf-8
require 'bigdecimal'
require 'big_money/currency'
require 'big_money/currency/iso4217'

# == Synopsis
#
#   bm = BigMoney.new('3.99', :aud)
#   bm.amount           #=> BigDecimal.new('3.99')
#   bm.currency         #=> BigMoney::Currency::AUD
#   bm.to_s             #=> '3.99'
#   bm.to_s('$.2f')     #=> '$3.99'
#   bm.to_s('$%.2f %s') #=> '$3.99 AUD'
#
# === Amount
#
# Amounts can be anything Numeric or Strings that are BigDecimal friendly. Keep in mind BigDecimal will silently return
# 0.0 for unrecognised strings. See BigMoney::Amount.
#
#   BigMoney.new(BigDecimal.new('12.50')) # BigDecimal
#   BigMoney.new(12)                      # Fixnum
#   BigMoney.new(12.50)                   # Float
#   BigMoney.new('12.50')                 # String
#
# === Currency
#
# Any currency defined by the current ISO4217 table on Wikipedia is already available. Naturally you may define your
# own currencies. See BigMoney::Currency.
#
# ==== Default
#
# A default currency risks exchanging an amount 1:1 between currencies if the default is unintentionally used.
# BigMoney expects an explicit currency in the constructor and will raise an ArugmentError unless one is given or a
# default currency set.
#
#   BigMoney::Currency.default = BigMoney::Currency::AUD # Module
#   BigMoney::Currency.default = 'AUD'                   # String, ISO4217 3 letter currency code.
#   BigMoney::Currency.default = :aud                    # Symbol, ISO4217 3 letter currency code.
class BigMoney
  include Comparable
  attr_reader :amount, :currency

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
  def self.currency(currency)
    Currency.find(currency)
  end

  # Create a BigMoney instance.
  #
  # ==== Parameters
  # amount<BigDecimal, Numeric, String>:: Numeric or BigDecimal friendly String.
  # currency<BigMoney::Currency, Symbol, String>:: Optional ISO-4217 3 letter currency code. Default BigMoney.currency.default
  #
  # ==== Returns
  # BigMoney
  def initialize(amount, currency = nil)
    @amount = case amount
      when BigDecimal then amount
      when String     then BigDecimal.new(amount)
      when Numeric    then BigDecimal.new(amount.to_s)
      else raise TypeError.new("Can't convert +amount+ #{amount.class} into BigDecimal.")
    end

    raise ArgumentError.new("Nil +currency+ without default.") if currency.nil? && !Currency.default?
    unless currency && @currency = Currency.find(currency)
      raise ArgumentError.new("Unknown +currency+ '#{currency.inspect}'.") unless Currency.default?
      @currency = Currency.default
    end
  end

  def zero?
    amount.zero?
  end

  def nonzero?
    amount.nonzero? && self
  end

  def positive?
    self > self.class.new(0, self.currency)
  end

  def negative?
    self < self.class.new(0, self.currency)
  end

  def <=>(money)
    money.kind_of?(self.class) ? (currency <=> money.currency).nonzero? || (amount <=> money.amount).nonzero? || 0 : nil
  end

  def eql?(money)
    money.kind_of?(self.class) &&
    amount == money.amount &&
    currency == money.currency
  end
  alias == eql?

  def -@
    self.class.new(-amount, currency)
  end

  [:+, :-, :*, :/].each do |op|
    define_method(op) do |rvalue|
      raise TypeError.new("Currency mismatch, '#{currency}' with '#{rvalue.currency}'.") \
        if rvalue.kind_of?(BigMoney) && currency != rvalue.currency

      rvalue = case rvalue
        when BigMoney   then rvalue.amount
        when BigDecimal then rvalue.dup
        when String     then BigDecimal.new(rvalue)
        when Numeric    then BigDecimal.new(rvalue.to_s)
        else raise TypeError.new("Can't convert +amount+ #{rvalue.class} into BigDecimal.")
      end
      self.class.new(amount.send(op, rvalue), currency)
    end
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
end # BigMoney
