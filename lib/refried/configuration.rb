module Refried
  # The Refried Configuration class
  #  based in general on the configuration approach in https://github.com/nesquena/backburner MIT license
  class Configuration
    PRIORITY_LABELS = { :high => 0, :medium => 100, :low => 200 }

    attr_accessor :beanstalk_url      # beanstalk url connection
    attr_accessor :reserve_timeout    # duration to wait to reserve on a single server

    def initialize
      @beanstalk_url     = "localhost"
      @reserve_timeout   = nil
    end
  end # Configuration
end # Refried