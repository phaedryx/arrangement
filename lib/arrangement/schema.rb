# frozen_string_literal: true

module Arrangement
  ##
  # TODO: explain this when it does more
  #
  class Schema < Hash
    def call_value(value)
      value.respond_to?(:call) ? value.call : value
    end

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

    def clone
      call_collect(super)
    end

    def dup
      call_collect(super)
    end

    def to_h
      call_collect(super)
    end

    class << self
      def load(string)
        hash = YAML.safe_load(string) || {}

        transform(hash)
      end

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
      private :transform # method with an eval should be private
    end
  end
end
