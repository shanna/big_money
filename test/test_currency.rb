# coding: utf-8
require 'helper'

class TestCurrency < Test::Unit::TestCase
  context BigMoney::Currency do
    should 'find' do
      assert_kind_of BigMoney::Currency, BigMoney::Currency.find(:aud)
      assert_raise(ArgumentError) do
        BigMoney::Currency.find(:fud)
      end
    end

    should 'be comparable' do
      aud = BigMoney::Currency::AUD.instance
      assert_operator aud, :==, :aud
      assert_operator aud, :==, :AUD
      assert_operator aud, :==, 'aud'
      assert_operator aud, :==, 'AUD'

      # assert_operator aud, '!=', :fud
      assert aud != :fud
      assert aud != :FUD
      assert aud != 'fud'
      assert aud != 'FUD'
    end
  end
end
