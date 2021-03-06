Gem::Specification.new do |s|
  s.name        = 'refried'
  s.version     = '0.1.0'
  s.date        = '2016-06-13'
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
      "lib/refried/tube.rb",
      "lib/refried/jobs.rb",
  ] # Remember don't add Rakefile or Gemfile to this list
  s.homepage    =
      'https://github.com/Referly/refried'
  s.add_runtime_dependency "beaneater", "~> 0.3", ">= 0.3.3"
  s.add_runtime_dependency "lincoln_logger", "~> 1.1"
  s.add_development_dependency "simplecov", "~> 0.9"
  s.license     = "MIT"
end