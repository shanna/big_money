# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class TestBigMoney < Test::Unit::TestCase
  context BigMoney do
    setup do
      BigMoney::Currency.default = BigMoney::Currency::USD
    end

    context '#new' do
      should 'initialize with big decimal' do
        decimal = BigDecimal.new('1.005')
        assert_same decimal, BigMoney.new(decimal).amount, 'Should not create clone of input'
      end

      should 'initialize with string' do
        assert_equal BigDecimal.new('1.005'), BigMoney.new('1.005').amount
        assert_equal BigDecimal.new('10'), BigMoney.new('10').amount
        assert_equal BigDecimal.new('0'), BigMoney.new('0').amount
        assert_equal BigDecimal.new('0'), BigMoney.new('foo').amount
      end

      should 'initialize with integer' do
        assert_equal BigDecimal.new("100"), BigMoney.new(100).amount
        assert_equal BigDecimal.new("0"), BigMoney.new(0).amount
      end

      should 'initialize with float' do
        assert_equal BigDecimal.new('1.005'), BigMoney.new(1.005).amount
        assert_equal BigDecimal.new('0'), BigMoney.new(0.0).amount
      end
    end

    context 'operators' do
      should 'eql?' do
        m1, m2 = BigMoney.new(1.00), BigMoney.new(1.50)
        assert m1.eql?(m1)
        assert !m1.eql?(m2)
      end

      should '<=> spaceship' do
        m1, m2 = BigMoney.new(1.00), BigMoney.new(1.50)
        assert_equal(-1, (m1 <=> m2))
        assert_equal(0, (m1 <=> m1))
        assert_equal(1, (m2 <=> m1))
      end

      should 'add' do
        m1, m2, m3 = BigMoney.new(1.00), BigMoney.new(1.50), BigMoney.new(0)
        assert_equal BigDecimal.new('2.50'), (m1 + m2).amount
        assert_equal BigDecimal.new('2.50'), (m2 + m1).amount
        assert_equal BigDecimal.new('1.00'), (m1 + m3).amount
        assert_equal BigDecimal.new('1.00'), (m3 + m1).amount
        assert_not_same m1, m1 + m3
        assert_not_same m1, m3 + m1
        assert_equal BigDecimal.new('5.50'), (m2 + 4).amount
        assert_equal BigDecimal.new('5.50'), (m2 + 4.00).amount
      end

      should 'subtract' do
        m1, m2, m3 = BigMoney.new(1.00), BigMoney.new(1.50), BigMoney.new(0)
        assert_equal BigDecimal.new('-0.50'), (m1 - m2).amount
        assert_equal BigDecimal.new('0.50'), (m2 - m1).amount
        assert_equal BigDecimal.new('1.00'), (m1 - m3).amount
        assert_equal BigDecimal.new('-1.00'), (m3 - m1).amount
        assert_equal BigDecimal.new('-2.50'), (m2 - 4).amount
        assert_equal BigDecimal.new('-2.50'), (m2 - 4.00).amount
      end

      should 'multiply' do
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

      should 'divide' do
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

      should 'negate' do
        assert_equal BigMoney.new(-1), -BigMoney.new(1)
        assert_equal BigMoney.new(1),  -BigMoney.new(-1)
        assert_equal BigMoney.new(1),  -BigMoney.new(-1)
      end
    end

    context 'serialization' do
      should '.to_s' do
        assert_equal '1.00', BigMoney.new(1).to_s
        assert_equal '1.50', BigMoney.new(1.5).to_s
        assert_equal '-11.50', BigMoney.new(-11.5).to_s
      end

      should 'formatted .to_s' do
        assert_equal '1.00', BigMoney.new(1).to_s('%.2f')
        assert_equal '$1.00', BigMoney.new(1).to_s('$%.2f')
      end

      should '.to_i' do
        assert_equal(1, BigMoney.new(1).to_i)
        assert_equal(1, BigMoney.new(1.5).to_i)
        assert_equal(-11, BigMoney.new(-11.5).to_i)
      end

      should '.to_f' do
        assert_in_delta(1.0, BigMoney.new(1).to_f, 0.000001)
        assert_in_delta(1.5, BigMoney.new(1.5).to_f, 0.000001)
        assert_in_delta(-11.5, BigMoney.new(-11.5).to_f, 0.000001)
      end
    end
  end
end

