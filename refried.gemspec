Gem::Specification.new do |s|
  s.name        = 'refried'
  s.version     = '0.0.5-dev'
  s.date        = '2014-11-23'
  s.summary     = "Beanstalk Client"
  s.description = "An enhancement"
  s.authors     = ["Courtland Caldwell"]
  s.email       = 'courtland@mattermark.com'
  s.files       = ["lib/refried.rb", "lib/refried/configuration.rb", "lib/refried/puter.rb", "lib/refried/tubes.rb"] # Remember don't add Rakefile or Gemfile to this list
  s.homepage    =
      'http://rubygems.org/gems/refried'
  s.add_runtime_dependency "beaneater", "~> 0.3", ">= 0.3.3"
  s.add_development_dependency "simplecov", "~> 0.9"
  s.license     = "MIT"
end