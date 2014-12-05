require 'beaneater'
require 'refried/configuration'
require 'refried/tubes'
require 'refried/puter'
require 'refried/getter'

# Refried core API methods
#  based in part on the design of backburner (https://github.com/nesquena/backburner MIT license)
module Refried
  class << self

    # Allows the user to set configuration options
    #  by yielding the configuration block
    #
    # @param block [Block]
    # @return [Configuration] the current configuration object
    def configure(&block)
      yield(configuration)
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