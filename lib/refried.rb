require 'beaneater'
require 'refried/configuration'
require 'refried/tubes'
require 'refried/puter'
require 'refried/getter'
require 'refried/tube'

# Refried core API methods
#  based in part on the design of backburner (https://github.com/nesquena/backburner MIT license)
module Refried
  class << self

    # Allows the user to set configuration options
    #  by yielding the configuration block
    #
    # @param opts [Hash] an optional hash of options, supported options are `reset: true`
    # @param block [Block] an optional configuration block
    # @return [Configuration] the current configuration object
    def configure(opts = {}, &block)
      if opts.has_key? :reset && opts[:reset]
        @configuration = nil
      end
      yield(configuration) if block_given?
      configuration
    end

    # Returns the singleton class's configuration object
    #
    # @return [Configuration] the current configuration object
    def configuration
      @configuration ||= Configuration.new
    end

    # Returns the Beaneater::Tubes object, which is the collection of all the Beaneater Tube objects
    #
    # @return [Beaneater::Tubes] the collection of Beaneater Tubes
    def tubes
      @tubes ||= Tubes.new
    end
  end
end