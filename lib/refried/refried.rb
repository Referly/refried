require_relative 'getter'
require_relative 'puter'

module Refried
  module Refried
    module ActsAsRefried
      def acts_as_refried
        send :include, InstanceMethods
        send :include, Getter::InstanceMethods
        send :include, Puter::InstanceMethods
        send :extend, ClassMethods
        send :extend, Getter::ClassMethods
        send :extend, Puter::ClassMethods
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def tube_name
        raise NoMethodError, "The method #tube_name is not defined."
      end

      def tube_name=(tube_name)
        raise NoMethodError, "The method #tube_name= is not defined."
      end
    end

    def self.included(base)
      base.extend(ActsAsRefried)
    end
  end
  Object.instance_eval { include Refried }
end