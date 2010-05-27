# encoding: utf-8
require 'bigdecimal'

class BigMoney

  # == Synopsis
  #
  #   require 'big_money'
  #   require 'big_money/exchange/yahoo' # Use yahoo finance exchange service.
  #
  #   bm = BigMoney.new('3.99', :usd)
  #   bm.amount   #=> BigDecimal.new('3.99')
  #   bm.currency #=> BigMoney::Currency::USD
  #
  #   bm2 = bm.exchange(:aud)
  #   bm.amount   #=> BigDecimal.new('5.22')
  #   bm.currency #=> BigMoney::Currency::AUD
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
  # ==== Notes
  #
  # No caching is done by default. You can set one though using anything that behaves like a Hash for example the
  # moneta library.
  #
  # ==== Example
  #
  #   require 'bigmoney/exchanage'
  #   require 'moneta/memcache'
  #
  #   BigMoney::Exchange.cache = Moneta::Memcache.new('localhost', default_ttl: 3_600)
  class Exchange
    class ConversionError < StandardError; end

    class << self
      def cache=(store)
        raise "Cache object #{store.class} does not respond to [] and []=." \
          unless store.respond_to?(:'[]') and store.respond_to?(:'[]=')
        @@cache = store
      end

      def cache
        @@cache ||= nil
      end

      @@services = []
      def inherited(service) #:nodoc:
        @@services << service
      end

      # Fetch the exchange rate between two currencies.
      #
      # ==== Parameters
      # from<BigMoney::Currency, .to_s>:: Anything that BigMoney::Currency#find can find.
      # to<BigMoney::Currency, .to_s>:: Anything that BigMoney::Currency#find can find.
      #
      # ==== Returns
      # BigDecimal
      def rate(from, to)
        exchange = []
        exchange << (Currency.find(from) or raise ArgumentError.new("Unknown +from+ currency #{from.inspect}."))
        exchange << (Currency.find(to) or raise ArgumentError.new("Unknown +to+ currency #{to.inspect}."))
        return BigDecimal.new(1.to_s) if exchange.uniq.size == 1 || exchange.find{|c| c == Currency::XXX}

        id = exchange.map{|c| c.code}.join(':')
        if cache && rate = cache[id]
          return rate
        end

        service = @@services.reverse.find do |service|
          !!exchange.reject{|c| service.currencies.include?(c)}
        end

        service or raise ConversionError # TODO: Message?
        rate = BigDecimal.new(service.read_rate(*exchange).to_s)

        cache[id] = rate if cache
        rate
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
