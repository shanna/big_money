require 'set'

class BigMoney
  class Currency
    include Comparable

    attr_accessor :code, :offset, :name
    alias to_s code

    def hash
      code.hash
    end

    def eql?(rvalue)
      self.class.equal?(rvalue.class) && code == rvalue.code
    end
    alias == eql?

    def <=>(rvalue)
      self.class == rvalue.class ? (code <=> rvalue.code) || 0 : nil
    end

    #--
    # TODO: Validate.
    def initialize(code, offset, name)
      @code, @offset, @name = code.to_s.upcase, offset, name
    end

    class << self
      def default
        raise "No default currency has been set. See BigMoney::Currency." unless default?
        @@default
      end

      def default=(currency)
        raise TypeError.new("Expected kind of BigMoney::Currency but got #{currency.class}.") \
          unless currency.kind_of?(Currency)
        @@default = currency
      end

      def default?
        defined? @@default
      end

      def all
        @@all ||= Set.new
      end

      # Find an existing currency module by Object, Symbol or String.
      #
      # ==== Examples
      #
      #   AUD = BigMoney::Currency.new(:aud, 2, 'Australian Dollar')
      #
      #   BigMoney::Currency.find(:aud)
      #   BigMoney::Currency.find('aud')
      #   BigMoney::Currency.find('AUD')
      #   BigMoney::Currency.find(AUD)
      def find(currency)
        if currency.is_a?(self)
          currency
        else
          currency = currency.to_s.upcase
          all.find{|c| c.code == currency}
        end
      end

      def register(*args)
        self.all << currency = new(*args).freeze
        currency
      end
    end
  end # Currency
end # BigMoney

