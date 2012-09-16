Gem::Specification.new do |s|
  s.name        = 'not_captcha'
  s.version     = '0.1.1'
  s.date        = '2012-09-16'
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = ">= 1.8.11"
  s.summary     = "Captcha"
  s.description = "Port of http://notcaptcha.webjema.com/?p=1"
  s.authors     = ["Andrew Bolshov"]
  s.email       = 'asnow.dev@gmail.com'
  s.files       = Dir['[A-Z]*', '{app,config,lib,images}/**/*']
  s.homepage    = 'http://github.org/asnow/not_captcha'
end