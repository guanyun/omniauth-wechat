# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-wechat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["feipinghuang"]
  gem.email         = ["feipinghuang"]
  gem.description   = %q{OmniAuth strategy for wechat.}
  gem.summary       = %q{OmniAuth strategy for wechat.}
  gem.homepage      = "https://github.com/feipinghunag/omniauth-wechat"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-wechat"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Wechat::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.1'
end
