# coding: utf-8

class String
  def to_big_money(currency = nil)
    BigMoney.new(self, currency)
  end
end

class Numeric
  def to_big_money(currency = nil)
    BigMoney.new(self, currency)
  end
end
