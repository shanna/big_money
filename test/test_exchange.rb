# encoding: utf-8
require_relative 'helper'
require 'big_money/exchange'

class TestEx < BigMoney::Exchange
  def self.read_rate(from, to)
    BigDecimal.new('2')
  end

  def self.currencies
    BigMoney::Currency.all
  end
end

describe BigMoney::Exchange do
  before do
    @aud = BigMoney.currency(:aud)
    @usd = BigMoney.currency(:usd)
  end

  it 'must return rate' do
    bd = BigDecimal.new('2')
    assert_equal bd, BigMoney::Exchange.rate(@aud, @usd)
    assert_equal bd, BigMoney::Exchange.rate(:aud, :usd)
    assert_raises(ArgumentError) do
      BigMoney::Exchange.rate(:aud, :fud)
    end
  end

  it 'must return equal rate' do
    assert_equal BigDecimal.new('1'), BigMoney::Exchange.rate(:usd, :usd)
    assert_equal BigDecimal.new('1'), BigMoney::Exchange.rate(:usd, :xxx)
    assert_equal BigDecimal.new('1'), BigMoney::Exchange.rate(:xxx, :usd)
  end

  it 'must be cacheable' do
    BigMoney::Exchange.cache = {}
    BigMoney::Exchange.rate(:usd, :aud)
    assert_equal BigDecimal.new('2'), BigMoney::Exchange.cache.values.first
  end
end
