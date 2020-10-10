# frozen_string_literal: true

module Arrangement
  ##
  # TODO: better comment
  #
  module Generators
    module_function

    def eval_binding
      binding
    end

    def add(name, &block)
      define_singleton_method(name, block)
    end

    def incrementer(start = 1, step = 1)
      enumerator = Enumerator.new do |yielder|
        loop do
          yielder << start
          start += step
        end
      end

      -> { enumerator.next }
    end

    def cycler(collection)
      enumerator = collection.cycle

      -> { enumerator.next }
    end

    def string_incrementer(string)
      lambda do
        temp = string
        string = string.next
        temp
      end
    end

    def random_number(min, max)
      -> { rand(max - min) + min }
    end
  end
end
