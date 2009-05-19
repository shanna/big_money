# coding: utf-8
require 'bigdecimal'

class BigMoney

  # == Synopsis
  #
  #   require 'big_money'
  #   require 'big_money/exchange/yahoo' # Use yahoo finance exchange service.
  #
  #   bm = BigMoney.new('3.99')
  #   bm.amount   #=> BigDecimal.new('3.99')
  #   bm.currency #=> BigMoney::Currency::USD.instance
  #
  #   bm2 = bm.exchange(:aud)
  #   bm.amount   #=> BigDecimal.new('5.22')
  #   bm.currency #=> BigMoney::Currency::AUD.instance
  module Exchangeable
    # Exchange to a new Currency.
    #
    # ==== Examples
    #
    #   BigMoney.new(12.50, :aud).exchange(:usd)
    #
    # ==== Parameters
    # from<BigMoney::Currency, #to_s>:: Anything that BigMoney::Currency#find can find.
    #
    # ==== Returns
    # BigMoney
    def exchange(to)
      ex = amount * Exchange.rate(currency, to)
      self.class.new(ex, to)
    end
  end # Exchangeable
  include Exchangeable

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

      # Fetch the exchange rate between two currencies.
      #
      # ==== Parameters
      # from<BigMoney::Currency, #to_s>:: Anything that BigMoney::Currency#find can find.
      # to<BigMoney::Currency, #to_s>:: Anything that BigMoney::Currency#find can find.
      #
      # ==== Returns
      # BigDecimal
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
        #
        # ==== Notes
        # Abstract.
        #
        # ==== Parameters
        # from<BigMoney::Currency>::
        # to<BigMoney::Currency>::
        #
        # ==== Returns
        # BigDecimal
        def read_rate(from, to)
          raise NotImplementedError
        end

        # Supported currencies.
        #
        # ==== Notes
        # Abstract.
        #
        # ==== Returns
        # Array<BigMoney::Currency, #to_s>:: Anything that BigMoney::Currency#find can find.
        def currencies
          raise NotImplementedError
        end
    end
  end # Exchange

end # Money
