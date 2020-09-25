# frozen_string_literal: true

module Arrangement
  ##
  # TODO: explain this when it does more
  #
  class Schema < Hash
    def call(value)
      value.respond_to?(:call) ? value.call : value
    end

    def transform(collection)
      case collection
      when Hash then collection.transform_values { |v| transform(v) }
      when Array then collection.map { |v| transform(v) }
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
      transform(super)
    end

    def dup
      transform(super)
    end

    def to_h
      transform(super)
    end

    def self.load(string)
      # Backticks are nice for readability but are not allowed in YAML so
      # replace them with something usable
      escaped_string = string.gsub(/`/, ';-;')
      hash = YAML.safe_load(escaped_string)

      hash.transform_keys!(&:to_sym)

      hash.transform_values! do |value|
        evaluable = value.to_s.match(/^;-;(.+?);-;$/)
        # rubocop:disable Security/Eval
        evaluable ? eval(evaluable[1], Arrangement::Enumerators.eval_binding) : value
        # rubocop:enable Security/Eval
      end

      new.merge(hash)
    end
  end
end
