module Refried
  class Tubes
    # TODO: connect to configuration
    def initialize
      @pool ||= Beaneater::Pool.new(::Refried.configuration.beanstalk_url)
      @tubes = @pool.tubes
    end

    def find(canonical_tube_name)
      @tubes.find canonical_tube_name
    end

  end
end