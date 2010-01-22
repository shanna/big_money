# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require 'big_money/parser'

class TestParser < Test::Unit::TestCase
  context BigMoney::Parser do
    setup do
      @xxx = BigMoney.new('1.50', :xxx)
      @aud = BigMoney.new('1.50', :aud)
      @jpy = BigMoney.new('1.50', :jpy)
    end

    should 'parse' do
      assert_equal @xxx, BigMoney.parse('1.50')
    end

    should 'parse scientific notation' do
      assert_equal @xxx, BigMoney.parse('0.15E1')
    end

    should 'parse with leading currency' do
      assert_equal @aud, BigMoney.parse('AUD 1.50')
      assert_equal @aud, BigMoney.parse('AUD1.50')
      assert_equal @aud, BigMoney.parse('AUD 0.15E1')
      assert_equal @aud, BigMoney.parse('AUD0.15E1')

      assert_equal @jpy, BigMoney.parse('JPY 1.50')
      assert_equal @jpy, BigMoney.parse('JPY1.50')
      assert_equal @jpy, BigMoney.parse('JPY 0.15E1')
      assert_equal @jpy, BigMoney.parse('JPY0.15E1')
    end

    should 'parse with trailing currency' do
      assert_equal @aud, BigMoney.parse('1.50 AUD')
      assert_equal @aud, BigMoney.parse('1.50AUD')
      assert_equal @aud, BigMoney.parse('0.15E1 AUD')
      assert_equal @aud, BigMoney.parse('0.15E1AUD')

      assert_equal @jpy, BigMoney.parse('1.50 JPY')
      assert_equal @jpy, BigMoney.parse('1.50JPY')
      assert_equal @jpy, BigMoney.parse('0.15E1 JPY')
      assert_equal @jpy, BigMoney.parse('0.15E1JPY')
    end

    should 'parse with currency symbols' do
      assert_equal @xxx, BigMoney.parse('$1.50')
      assert_equal @xxx, BigMoney.parse('¤1.50')
      assert_equal @xxx, BigMoney.parse('¥1.50')

      assert_equal @xxx, BigMoney.parse('$ 1.50')
      assert_equal @xxx, BigMoney.parse('¤ 1.50')
      assert_equal @xxx, BigMoney.parse('¥ 1.50')
    end

    should 'parse with currency and symbols' do
      assert_equal @aud, BigMoney.parse('AUD ¤ 1.50')
      assert_equal @aud, BigMoney.parse('AUD ¤1.50')
      assert_equal @aud, BigMoney.parse('AUD¤ 1.50')
      assert_equal @aud, BigMoney.parse('AUD¤1.50')

      assert_equal @aud, BigMoney.parse('¤ 1.50 AUD')
      assert_equal @aud, BigMoney.parse('¤ 1.50AUD')
      assert_equal @aud, BigMoney.parse('¤1.50 AUD')
      assert_equal @aud, BigMoney.parse('¤1.50AUD')
    end
  end
end
