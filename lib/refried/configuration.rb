module Refried
  # The Refried Configuration class
  #  based in general on the configuration approach in https://github.com/nesquena/backburner MIT license
  class Configuration
    PRIORITY_LABELS = { :high => 0, :medium => 100, :low => 200 }

    attr_accessor :beanstalk_url      # beanstalk url connection

    def initialize
      @beanstalk_url     = ["localhost"]
    end
  end # Configuration
end # Refried