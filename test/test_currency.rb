require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class TestCurrency < Test::Unit::TestCase
  context BigMoney::Currency do
    should 'find' do
      assert_kind_of BigMoney::Currency, BigMoney::Currency.find(:aud)
      assert_kind_of BigMoney::Currency, BigMoney::Currency.find(:AUD)
      assert_kind_of BigMoney::Currency, BigMoney::Currency.find('aud')
      assert_kind_of BigMoney::Currency, BigMoney::Currency.find('AUD')
      assert_nil     BigMoney::Currency.find(:fud)
    end

    should 'be comparable' do
      aud = BigMoney::Currency::AUD
      assert_operator aud, :==, BigMoney::Currency::AUD
      assert aud != BigMoney::Currency::USD
    end

    context 'default' do
      should 'raise exception for bad type' do
        assert_raise(TypeError) { BigMoney::Currency.default = :fud}
      end

      should 'be settable' do
        assert_nothing_raised{ BigMoney::Currency.default = BigMoney::Currency::AUD}
        assert_kind_of BigMoney::Currency, BigMoney::Currency.default
        assert_equal BigMoney::Currency::AUD, BigMoney::Currency.default
      end

      should 'be ackowledged' do
        BigMoney::Currency.default = BigMoney::Currency::AUD
        assert BigMoney::Currency.default?
      end
    end
  end
end
