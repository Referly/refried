require_relative 'getter'
require_relative 'puter'

module Refried
  module Tube
    module ActsAsTube
      def acts_as_tube
        send :include, InstanceMethods
        send :include, Getter::InstanceMethods
        send :include, Puter::InstanceMethods
        send :extend, ClassMethods
        send :extend, Getter::ClassMethods
        send :extend, Puter::ClassMethods
      end
    end

    module ClassMethods
      # Acts as both a getter and setter (without = sign) method for the @tube_mode attribute
      #
      # @param mode [Symbol] what mode to use for puter and getter
      # @return [Symbol] the current mode
      def tube_mode(mode = nil)
        unless mode.nil?
          self.tube_mode = mode
        end
        @tube_mode ||= nil
      end

      # Sets the current tube_mode, also sets the puter_mode and getter_mode
      #
      # @param mode [Symbol] what mode to set the tube_mode to
      def tube_mode=(mode)
        @tube_mode = mode
        self.puter_mode = mode
        self.getter_mode = mode
      end

    end

    module InstanceMethods
      def tube_name
        unless self.puter_tube_name == self.getter_tube_name
          raise ArgumentError, "The method #tube_name is only usable when the puter_tube_name is equal to the getter_tube_name."
        end
        self.puter_tube_name
      end

      def tube_name=(tube_name)
        self.puter_tube_name = tube_name
        self.getter_tube_name = tube_name
      end
    end

    def self.included(base)
      base.extend(ActsAsTube)
    end
  end
  Object.instance_eval { include Tube }
end