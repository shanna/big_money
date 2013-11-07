require_relative 'helper'

describe BigMoney::Currency do
  it 'must find' do
    assert_kind_of BigMoney::Currency, BigMoney::Currency.find(:aud)
    assert_kind_of BigMoney::Currency, BigMoney::Currency.find(:AUD)
    assert_kind_of BigMoney::Currency, BigMoney::Currency.find('aud')
    assert_kind_of BigMoney::Currency, BigMoney::Currency.find('AUD')
    assert_nil     BigMoney::Currency.find(:fud)
  end

  it 'must be comparable' do
    aud = BigMoney::Currency::AUD
    assert_operator aud, :==, BigMoney::Currency::AUD
    assert aud != BigMoney::Currency::USD
  end

  describe 'default' do
    it 'must raise exception for bad type' do
      assert_raises(TypeError) { BigMoney::Currency.default = :fud}
    end

    it 'must be settable' do
      BigMoney::Currency.default = BigMoney::Currency::AUD
      assert_kind_of BigMoney::Currency, BigMoney::Currency.default
      assert_equal BigMoney::Currency::AUD, BigMoney::Currency.default
    end

    it 'must be ackowledged' do
      BigMoney::Currency.default = BigMoney::Currency::AUD
      assert BigMoney::Currency.default?
    end
  end
end
