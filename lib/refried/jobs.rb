module Refried
  class Jobs
    def initialize
      @pool ||= Beaneater::Pool.new(::Refried.configuration.beanstalk_url)
      @jobs = @pool.jobs
    end

    def find(job_id)
      @jobs.find job_id
    end
  end
end