# coding: utf-8
require 'bigdecimal'

class BigMoney
  # Exchange to a new Currency.
  #
  #   BigMoney.new(12.50, :aud).exchange(:usd)
  def exchange(to)
    ex = amount * Exchange.rate(currency, to)
    BigMoney.new(ex, to)
  end

  # Find the exchange rate between two currencies.
  #
  # Be aware no caching is done at all at the moment.
  #--
  # TODO: Moneta would be ideal for this.
  class Exchange
    class ConversionError < StandardError; end

    class << self
      @@services = []
      def inherited(service) #:nodoc:
        @@services << service
      end

      # Fetch the exchange rate between two currencies. The arguments may be anything that BigMoney::Currency can
      # parse. The rate is returned as a BigDecimal.
      def rate(from, to)
        exchange = [from, to].map{|c| Currency.find(c)}
        return BigDecimal(1.to_s) if exchange.uniq.length == 1

        service = @@services.reverse.find do |service|
          !!exchange.reject{|c| service.currencies.include?(c)}
        end

        service or raise ConversionError # TODO: Message?
        BigDecimal.new(service.read_rate(*exchange).to_s)
      end

      protected
        # Exchange rate from the first currency to the second.
        def read_rate(from, to)
          raise NotImplementedError
        end

        # An array of supported currencies.
        def currencies
          raise NotImplementedError
        end
    end
  end # Exchange

end # Money
