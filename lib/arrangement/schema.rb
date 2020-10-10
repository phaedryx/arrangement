# frozen_string_literal: true

module Arrangement
  ##
  # The Arrangement::Schema class is a specialized Hash. The difference is that it returns the call
  # value of a value if a value is callable.
  class Schema < Hash
    ##
    # This returns the value of a call if it is callable, otherwise the value. This is the key
    # behavior that sets Schema appart from a regular Hash.
    #
    # @param value [Object]
    # @return [Object]
    def call_value(value)
      value.respond_to?(:call) ? value.call : value
    end

    ##
    # This is the same functionality as `call_value`, but across a collection (`Array` or `Hash`).
    #
    # @param collection [Array|Hash]
    # @return [Object]
    def call_collect(collection)
      case collection
      when Hash then collection.transform_values { |v| call_collect(v) }
      when Array then collection.map { |v| call_collect(v) }
      else call_value(collection)
      end
    end

    def [](key)
      call_value(super)
    end

    def fetch(key)
      call_value(super)
    end

    # @return [Hash]
    def to_h
      call_collect(super)
    end

    class << self
      ##
      # This transforms a yaml-style string into an instace of `Arrangement::Schema`.
      #
      # @param string [String]
      # @return [Arrangement::Schema]
      def load(string)
        hash = YAML.safe_load(string) || {}

        transform(hash)
      end

      ##
      # This loads a yaml file and transforms it into an instance of `Arrangement::Schema`.
      #
      # @param path [String] the path to the file to load
      # @return [Arrangement::Schema]
      def load_file(path)
        load(File.read(path))
      end

      def transform(collection)
        case collection
        when Hash
          collection = new.merge(collection)
          collection.transform_keys!(&:to_sym)
          collection.transform_values! { |v| transform(v) }
        when Array
          collection.map { |v| transform(v) }
        else
          evaluable = collection.to_s.match(/^<=(.+?)$/)
          # rubocop:disable Security/Eval
          evaluable ? eval(evaluable[1], Arrangement::Generators.eval_binding) : collection
          # rubocop:enable Security/Eval
        end
      end
      # make this method private because it eval's
      private :transform
    end
  end
end
