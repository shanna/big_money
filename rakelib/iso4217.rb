# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'gems', 'environment')
require 'hpricot'
require 'open-uri'
require 'erubis'

class BigMoney
  module Task
    module ISO4217
      def self.get
        doc   = Hpricot(open('http://en.wikipedia.org/wiki/ISO_4217').read)
        codes = doc.at('#Active_codes').parent
        codes.name =~ /table/ && break while codes = codes.next_sibling
        to_ruby(codes) if codes
      end

      def self.to_ruby(codes)
        currencies = (codes / 'tr').map{|tr| currency tr}.compact
        currencies.reject!{|c| c[:code] !~ /[A-Z]{3}/ || c[:name] !~ /\w+/}
        tmpl  = File.read(File.join(File.dirname(__FILE__), 'iso4217.rb.erb'))
        eruby = Erubis::Eruby.new(tmpl)
        eruby.result(:currencies => currencies)
      end

      def self.currency(tr)
        values = (tr / 'td')
        return unless values && values.size >= 4
        {
          :code   => code(values),
          :name   => name(values),
          :offset => offset(values)
        }
      end

      def self.code(chunks)
        chunks[0].inner_html
      end

      def self.offset(chunks)
        chunks[2].inner_html.to_i rescue 0
      end

      def self.name(chunks)
        name = (chunks[3] / 'a').inner_html rescue nil
        (name.nil? || name.empty?) ? chunks[3].inner_html : name
      end
    end # ISO4217
  end # Task
end # BigMoney
