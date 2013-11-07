Gem::Specification.new do |s|
  s.name          = 'big_money'
  s.version       = '1.2.2'
  s.authors       = ['Shane Hanna', 'Marshall Roch']
  s.date          = '2012-12-21'
  s.summary       = 'BigDecimal backed amount of money in a particular currency.'
  s.description   = 'BigDecimal backed amount of money in a particular currency.'
  s.email         = ['shane.hanna@gmail.com', 'mroch@cmu.edu']
  s.licenses      = %w{MIT}
  s.homepage      = 'http://github.com/shanna/big_money'
  s.require_paths = %w{lib}

  s.files            = `git ls-files`.split("\n").reject{|f| f =~ %r{\.gitignore|examples|benchmarks|memory|gems/.*|Gemfile}}
  s.test_files       = `git ls-files -- test/*`.split("\n")
  s.extra_rdoc_files = %w{LICENSE README.md}

  s.add_development_dependency 'erubis'
  s.add_development_dependency 'hpricot'
  s.add_development_dependency 'minitest', '>= 1.7.0'
end

