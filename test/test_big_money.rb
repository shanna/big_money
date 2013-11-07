# encoding: utf-8
require_relative 'helper'

describe BigMoney do
  before do
    BigMoney::Currency.default = BigMoney::Currency::USD
  end

  describe '#new' do
    it 'must initialize with big decimal' do
      decimal = BigDecimal.new('1.005')
      assert_same decimal, BigMoney.new(decimal).amount, 'Should not create clone of input'
    end

    it 'must initialize with string' do
      assert_equal BigDecimal.new('1.005'), BigMoney.new('1.005').amount
      assert_equal BigDecimal.new('10'), BigMoney.new('10').amount
      assert_equal BigDecimal.new('0'), BigMoney.new('0').amount
      assert_equal BigDecimal.new('0'), BigMoney.new('foo').amount
    end

    it 'must initialize with integer' do
      assert_equal BigDecimal.new("100"), BigMoney.new(100).amount
      assert_equal BigDecimal.new("0"), BigMoney.new(0).amount
    end

    it 'must initialize with float' do
      assert_equal BigDecimal.new('1.005'), BigMoney.new(1.005).amount
      assert_equal BigDecimal.new('0'), BigMoney.new(0.0).amount
    end
  end

  describe 'operators' do
    it 'must be eql?' do
      m1, m2 = BigMoney.new(1.00), BigMoney.new(1.50)
      assert m1.eql?(m1)
      assert !m1.eql?(m2)
    end

    it 'must <=> spaceship' do
      m1, m2 = BigMoney.new(1.00), BigMoney.new(1.50)
      assert_equal(-1, (m1 <=> m2))
      assert_equal(0, (m1 <=> m1))
      assert_equal(1, (m2 <=> m1))
    end

    it 'must add' do
      m1, m2, m3 = BigMoney.new(1.00), BigMoney.new(1.50), BigMoney.new(0)
      assert_equal BigDecimal.new('2.50'), (m1 + m2).amount
      assert_equal BigDecimal.new('2.50'), (m2 + m1).amount
      assert_equal BigDecimal.new('1.00'), (m1 + m3).amount
      assert_equal BigDecimal.new('1.00'), (m3 + m1).amount
      assert_equal BigDecimal.new('5.50'), (m2 + 4).amount
      assert_equal BigDecimal.new('5.50'), (m2 + 4.00).amount
    end

    it 'must subtract' do
      m1, m2, m3 = BigMoney.new(1.00), BigMoney.new(1.50), BigMoney.new(0)
      assert_equal BigDecimal.new('-0.50'), (m1 - m2).amount
      assert_equal BigDecimal.new('0.50'), (m2 - m1).amount
      assert_equal BigDecimal.new('1.00'), (m1 - m3).amount
      assert_equal BigDecimal.new('-1.00'), (m3 - m1).amount
      assert_equal BigDecimal.new('-2.50'), (m2 - 4).amount
      assert_equal BigDecimal.new('-2.50'), (m2 - 4.00).amount
    end

    it 'must multiply' do
      m1, m2, m3 = BigMoney.new(2.00), BigMoney.new(1.50), BigMoney.new(0)
      assert_equal BigDecimal.new('4.00'), (m1 * m1).amount
      assert_equal BigDecimal.new('3.00'), (m1 * m2).amount
      assert_equal BigDecimal.new('3.00'), (m2 * m1).amount
      assert_equal BigDecimal.new('0'), (m1 * m3).amount
      assert_equal BigDecimal.new('0'), (m3 * m1).amount
      assert_equal BigDecimal.new('0'), (m3 * m3).amount
      assert_equal BigDecimal.new('3.00'), (m2 * 2).amount
      assert_equal BigDecimal.new('3.00'), (m2 * 2.00).amount
    end

    it 'must divide' do
      m1, m2, m3 = BigMoney.new(2.00), BigMoney.new(1.50), BigMoney.new(0)
      assert_equal BigDecimal.new('1.00'), (m1 / m1).amount
      assert_equal BigDecimal.new('0.75'), (m2 / m1).amount
      assert_equal BigDecimal.new('0'), (m3 / m1).amount
      assert((m1 / m3).amount.infinite?)
      assert((m3 / m3).amount.nan?)
      assert((m1 / 0).amount.infinite?)
      assert((m3 / 0).amount.nan?)
      assert_equal BigDecimal.new('0.75'), (m2 / 2).amount
      assert_equal BigDecimal.new('0.75'), (m2 / 2.00).amount
    end

    it 'must negate' do
      assert_equal BigMoney.new(-1), -BigMoney.new(1)
      assert_equal BigMoney.new(1),  -BigMoney.new(-1)
      assert_equal BigMoney.new(1),  -BigMoney.new(-1)
    end

    it 'must be zero?' do
      assert_equal BigMoney.new(-1.05).zero?, false
      assert_equal BigMoney.new(-1).zero?,    false
      assert_equal BigMoney.new(0).zero?,     true
      assert_equal BigMoney.new(0.0).zero?,   true
      assert_equal BigMoney.new(1).zero?,     false
      assert_equal BigMoney.new(1.05).zero?,  false
    end

    it 'must be nonzero?' do
      assert_equal BigMoney.new(-1.05).nonzero?, BigMoney.new(-1.05)
      assert_equal BigMoney.new(-1).nonzero?,    BigMoney.new(-1)
      assert_equal BigMoney.new(0).nonzero?,     nil
      assert_equal BigMoney.new(0.0).nonzero?,   nil
      assert_equal BigMoney.new(1).nonzero?,     BigMoney.new(1)
      assert_equal BigMoney.new(1.05).nonzero?,  BigMoney.new(1.05)
    end

    it 'must be negative?' do
      assert_equal BigMoney.new(-1.05).negative?, true
      assert_equal BigMoney.new(-1).negative?,    true
      assert_equal BigMoney.new(0).negative?,     false
      assert_equal BigMoney.new(0.0).negative?,   false
      assert_equal BigMoney.new(1).negative?,     false
      assert_equal BigMoney.new(1.05).negative?,  false
    end

    it 'must be positive?' do
      assert_equal BigMoney.new(-1.05).positive?, false
      assert_equal BigMoney.new(-1).positive?,    false
      assert_equal BigMoney.new(0).positive?,     false
      assert_equal BigMoney.new(0.0).positive?,   false
      assert_equal BigMoney.new(1).positive?,     true
      assert_equal BigMoney.new(1.05).positive?,  true
    end
  end

  describe 'serialization' do
    it 'must .to_s' do
      assert_equal '1.00', BigMoney.new(1).to_s
      assert_equal '1.50', BigMoney.new(1.5).to_s
      assert_equal '-11.50', BigMoney.new(-11.5).to_s
    end

    it 'must formatted .to_s' do
      assert_equal '1.00', BigMoney.new(1).to_s('%.2f')
      assert_equal '$1.00', BigMoney.new(1).to_s('$%.2f')
    end

    it 'must .to_i' do
      assert_equal(1, BigMoney.new(1).to_i)
      assert_equal(1, BigMoney.new(1.5).to_i)
      assert_equal(-11, BigMoney.new(-11.5).to_i)
    end

    it 'must .to_f' do
      assert_in_delta(1.0, BigMoney.new(1).to_f, 0.000001)
      assert_in_delta(1.5, BigMoney.new(1.5).to_f, 0.000001)
      assert_in_delta(-11.5, BigMoney.new(-11.5).to_f, 0.000001)
    end
  end
end

