# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require 'big_money/exchange'

class TestEx < BigMoney::Exchange
  def self.read_rate(from, to)
    BigDecimal.new('2')
  end

  def self.currencies
    BigMoney::Currency.all
  end
end

class TestExchange < Test::Unit::TestCase
  context BigMoney::Exchange do
    setup do
      @aud = BigMoney.currency(:aud)
      @usd = BigMoney.currency(:usd)
    end

    should 'return rate' do
      bd = BigDecimal.new('2')
      assert_equal bd, BigMoney::Exchange.rate(@aud, @usd)
      assert_equal bd, BigMoney::Exchange.rate(:aud, :usd)
      assert_raise(ArgumentError) do
        BigMoney::Exchange.rate(:aud, :fud)
      end
    end

    should 'return equal rate' do
      assert_equal BigDecimal.new('1'), BigMoney::Exchange.rate(:usd, :usd)
      assert_equal BigDecimal.new('1'), BigMoney::Exchange.rate(:usd, :xxx)
      assert_equal BigDecimal.new('1'), BigMoney::Exchange.rate(:xxx, :usd)
    end

    should 'be cacheable' do
      BigMoney::Exchange.cache = {}
      BigMoney::Exchange.rate(:usd, :aud)
      assert_equal BigDecimal.new('2'), BigMoney::Exchange.cache.values.first
    end
  end
end
