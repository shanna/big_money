# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{big_money}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marshall Roch", "Shane Hanna"]
  s.date = %q{2009-05-18}
  s.email = ["mroch@cmu.edu", "shane.hanna@gmail.com"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "Rakefile",
     "big_money.gemspec",
     "lib/big_money.rb",
     "lib/big_money/big_money.rb",
     "lib/big_money/core_extensions.rb",
     "lib/big_money/currency.rb",
     "lib/big_money/currency/iso4217.rb",
     "lib/big_money/exchange.rb",
     "lib/big_money/exchange/yahoo.rb",
     "rakelib/iso4217.rb",
     "rakelib/iso4217.rb.erb",
     "test/test_big_money.rb",
     "test/test_currency.rb",
     "test/test_exchange.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mroch/big_money}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{BigDecimal backed amount of money in a particular currency.}
  s.test_files = [
    "test/helper.rb",
     "test/test_big_money.rb",
     "test/test_currency.rb",
     "test/test_exchange.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
