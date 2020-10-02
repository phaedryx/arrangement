# frozen_string_literal: true

module Arrangement
  ##
  # TODO: explain this when it does more
  #
  class Schema < Hash
    def call(value)
      value.respond_to?(:call) ? value.call : value
    end

    def collect_call(collection)
      case collection
      when Hash then collection.transform_values { |v| collect_call(v) }
      when Array then collection.map { |v| collect_call(v) }
      else call(collection)
      end
    end

    def [](key)
      call(super)
    end

    def fetch(key)
      call(super)
    end

    def clone
      collect_call(super)
    end

    def dup
      collect_call(super)
    end

    def to_h
      collect_call(super)
    end

    class << self
      def load(string)
        # Backticks are nice for readability but are not allowed in YAML so
        # replace them with something usable
        escaped_string = string.gsub(/`/, ';-;')
        hash = YAML.safe_load(escaped_string)

        new.merge(transform(hash))
      end

      def load_file(path)
        load(File.read(path))
      end

      ##
      # something with an eval should be private
      #
      def transform(collection)
        case collection
        when Hash
          collection.transform_keys!(&:to_sym)
          collection.transform_values! { |v| transform(v) }
        when Array
          collection.map { |v| transform(v) }
        else
          evaluable = collection.to_s.match(/^;-;(.+?);-;$/)
          # rubocop:disable Security/Eval
          evaluable ? eval(evaluable[1], Arrangement::Generators.eval_binding) : collection
          # rubocop:enable Security/Eval
        end
      end
      private :transform
    end
  end
end
