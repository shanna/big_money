BigMoney
========

## Description

Represents an amount of money in a particular currency. Backed by BigDecimal, so it's safe from float rounding errors.

## Features

* Encapsulates an amount with its currency into a single object.
* Backed by BigDecimal, so it can store arbitrary-precision values without rounding errors. Useful if you're dealing
  with fractional cents.
* Sensible currency handling.
* Supports all ISO-4217 currencies.
* Optional currency exchange.
* Optional string parsing.

## Problems

* Does not implement all of Numeric, so doesn't quite act like a real number.

## Todo

* Has no Money package API compatibility to ease transition (module patch welcome).
  (http://dist.leetsoft.com/api/money/)

## Synopsis

### Basic

```ruby
  require 'big_money'

  bm = BigMoney.new('3.99', :aud)
  bm.amount           #=> BigDecimal.new('3.99')
  bm.currency         #=> BigMoney::Currency::AUD
  bm.to_s             #=> '3.99'
  bm.to_s('$.2f')     #=> '$3.99'
  bm.to_s('$%.2f %s') #=> '$3.99 AUD'

  # Not recommended but if you must.
  BigMoney::Currency.default = :aud

  bm = BigMoney.new('3.99')
  bm.amount   #=> BigDecimal.new('3.99')
  bm.currency #=> BigMoney::Currency::AUD

  bm2 = 1.to_big_money
  bm2.amount   #=> BigDecimal.new('3.99')
  bm2.currency #=> BigMoney::Currency::AUD
```

### Exchange

```ruby
  require 'big_money'
  require 'big_money/exchange/yahoo' # Use yahoo finance exchange service.

  # Cache it with memcache.
  require 'moneta'
  require 'moneta/memcache'
  BigMoney::Exchange.cache = Moneta::Memcache.new(server: 'localhost', default_ttl: 3_600)

  bm = BigMoney.new('3.99', :usd)
  bm.amount   #=> BigDecimal.new('3.99')
  bm.currency #=> BigMoney::Currency::USD

  bm2 = bm.exchange(:aud)
  bm.amount   #=> BigDecimal.new('5.22')
  bm.currency #=> BigMoney::Currency::AUD
```

### Parser

```ruby
  require 'big_money'
  require 'big_money/parser'

  BigMoney.parse('JPY ¥2500') #=> BigMoney.new('2500', :jpy)
  BigMoney.parse('JPY2500')   #=> BigMoney.new('2500', :jpy)
  BigMoney.parse('2500JPY')   #=> BigMoney.new('2500', :jpy)
  BigMoney.parse('¥2500JPY')  #=> BigMoney.new('2500', :jpy)

  # ISO-4217 BigMoney::Currency::XXX aka 'No currency' will be used if a currency cannot be parsed along with the
  # amount. If you know the currency and just need the amount XXX is always exchanged 1:1 with any currency.
  bm = BigMoney.parse('¥2500') #=> BigMoney.new('2500', :xxx)
  bm.exchange(:jpy)            #=> BigMoney.new('2500', :jpy)
```

### Types

```ruby
  require 'big_money'
  require 'big_money/types'

  # Numeric
  1.to_big_money(:aud)         #=> BigMoney.new(1, :aud)
  12_123.44.to_big_money(:aud) #=> BigMoney.new('12123.44', :aud)

  # String
  '1'.to_big_money(:aud)       #=> BigMoney.new(1, :aud)
```

## Install

* Via git:

```
    git clone git://github.com/shanna/big_money.git
```

* Via gem:

```
    gem install big_money
```

## Contributing

Go nuts! There is no style guide, I do not care if you write tests or comment
code because I can do that stuff for you. If you write something neat just send
a pull request, tweet, email or yell it at me line by line in person.

## License

MIT
