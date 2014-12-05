require 'beaneater'
require 'byebug'

module Refried
  module Getter
    module ActsAsGetter
      def acts_as_getter
        send :include, InstanceMethods
        send :extend, ClassMethods
      end
    end

    module ClassMethods
      SUPPORTED_MODES = [:tube_name]
      # Set the mode of function that the Getter should follow
      #
      # @param mode [Symbol] which mapping mode the getter uses, `:tube_name`
      def getter_mode=(mode)
        unless SUPPORTED_MODES.include? mode
          raise ArgumentError, "Unsupported mode for acts_as_getter."
        end
        @getter_mode = mode
      end
      alias_method :get_mode, :getter_mode=
      # Get the current mapping mode of the Getter
      #
      # @return [Symbol] the current mapping mode of the getter
      def getter_mode
        @getter_mode ||= :tube_name
      end
    end

    module InstanceMethods
      # Get the currently registered tube name
      #
      # @return [Symbol] the tube name
      def tube_name
        @tube_name ||= nil
      end

      # Set the tube name - this only has an impact when using the :tube_name getter mode
      #
      # @param tube_name [Symbol] the value to set the tube name
      def tube_name=(tube_name)
        @tube_name = tube_name
      end

      # Get a the next job from the tube
      #
      # @return [Beanstalk::Job] the next job from the tube
      def get
        tube = Refried.tubes.find self.tube_name.to_s
        tube.reserve
      end

      protected
      def locatable? (selectors = {})
        case self.class.getter_mode
          when :tube_name
            true
          else
            false
        end
      end

      def attempt_to_log (message)
        begin
          logger.info message
        rescue => e
          #puts "Failed to access logger, message that should have been logged = #{message}"
        end
      end
    end

    def self.included(base)
      base.extend(ActsAsGetter)
    end
  end
  Object.instance_eval { include Getter }
end