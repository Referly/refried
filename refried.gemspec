Gem::Specification.new do |s|
  s.name        = 'refried'
  s.version     = '0.0.6-rc1'
  s.date        = '2014-12-05'
  s.summary     = "Make Ruby objects behave like Beanstalk tubes"
  s.description = "Provides acts_as_ mixins for adding Beanstalk tube functionality to your existing Ruby objects."
  s.authors     = ["Courtland Caldwell"]
  s.email       = 'courtland@mattermark.com'
  s.files       = [
      "lib/refried.rb",
      "lib/refried/configuration.rb",
      "lib/refried/puter.rb",
      "lib/refried/tubes.rb",
      "lib/refried/getter.rb",
      "lib/refried/tube.rb"
  ] # Remember don't add Rakefile or Gemfile to this list
  s.homepage    =
      'https://github.com/caldwecr/refried'
  s.add_runtime_dependency "beaneater", "~> 0.3", ">= 0.3.3"
  s.add_development_dependency "simplecov", "~> 0.9"
  s.license     = "MIT"
end