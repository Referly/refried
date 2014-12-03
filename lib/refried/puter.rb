require 'beaneater'

module Refried
  module Puter
    module ActsAsPuter
      def acts_as_puter
        send :include, InstanceMethods
        send :extend, ClassMethods
      end
    end

    module ClassMethods
      SUPPORTED_MODES = [:simple, :type_map, :alias_map]

      # Set the mode of function that the Puter should follow
      #
      # @param mode [Symbol] which mapping mode the puter uses, `:simple`, `:type_map` or `:alias_map`
      def puter_mode=(mode)
        unless SUPPORTED_MODES.include? mode
          raise ArgumentError, "Unsupported mode for acts as puter."
        end
        @puter_mode = mode
      end

      # Get the current mapping mode of the Puter
      #
      # @return [Symbol] the current mapping mode of the Puter
      def puter_mode
        @puter_mode ||= :simple
      end
    end

    module InstanceMethods

      def puter_tube_alias_map
        @puter_tube_alias_map ||= Hash.new
      end
      alias_method :alias_map, :puter_tube_alias_map

      def puter_tube_alias_map=(alias_map)
        @puter_tube_alias_map = alias_map
      end

      # I want to support a number of types of mappings
      # 1. in the simple case the tube name should be associated with the Puter's class
      # 2. a map of item types to tube names
      # 3. a map of tube aliases to tube names (this corresponds to how ESIndexer & funding override workers will use the gem)
      def put (item, tube_alias = nil)
        self.attempt_to_log "Puter#put message received. #{item} and tube_alias #{tube_alias}"
        tube = self.tube(alias: tube_alias)
        payload = self.generate_message item
        r = tube.put payload
        self.attempt_to_log "Puter#put message queued containing #{item}, result = #{r}"
        r
      end

      # Get the Beaneater Tube object for the current class, the item, and the alias

      # If the puter mode is :type_map the :type key should contain the class of the item being put as a symbol, which should be a key in the puter_tube_type_map
      # If the puter mode is :alias_map the value for the :alias key is the tube_alias,
      #   the tube_alias is used as the key in the puter_tube_alias_map whose value is the tube's name

      def tube (selectors = {})
        unless self.locatable? selectors
          a_map = self.alias_map
          a_map ||= nil
          raise ArgumentError, "Selectors to #tube were unexpected for current puter_mode; alias_map = #{a_map}; puter mode = #{self.class.puter_mode}; selectors = #{selectors}"
        end
        case self.class.puter_mode
          when :simple
            tube_name = self.class.to_s.downcase
          when :alias_map
            tube_alias = selectors[:alias]
            tube_name = self.alias_map[tube_alias]
          else
            raise ArgumentError, 'Invalid puter mode detected in the #tube method.'
        end
        tube_name ||= nil
        tube ||= Refried.tubes.find tube_name
      end

      # This method converts the payload object into a format for injection
      #  into the queue
      #
      # @param payload the object that should be converted into a message (it must respond to the to_json method)
      # @return [String] the appropriately serialized representation of the payload
      def generate_message(payload)
        if payload.is_a? Fixnum
          payload.to_json
        else
          if payload.nil?
            nil
          elsif payload.respond_to?(:empty?) && payload.empty?
            nil
          elsif payload.respond_to? :to_edible
            payload.to_edible
          else
            # Not sure that this is the appropriate implementation, perhaps to_s is better
            payload.to_json
          end
        end
      end

    protected
      def locatable? (selectors = {})
        case self.class.puter_mode
          when :simple
            selectors.nil? || selectors.is_a?(Hash) && selectors.count == 0
          when :alias_map
            if selectors.is_a? Hash
              l = selectors.has_key?(:alias) && selectors[:alias].is_a?(Symbol) && self.alias_map.has_key?(selectors[:alias])
            end
            l ||= false
          else
            false
        end
      end

      def attempt_to_log (message)
        begin
          logger.info message
        rescue => e
          puts "Failed to access logger, message that should have been logged = #{message}"
        end
      end
    end

    def self.included(base)
      base.extend(ActsAsPuter)
    end
  end
  Object.instance_eval { include Puter }
end