# frozen_string_literal: true

module Arrangement
  ##
  # TODO: better comment
  #
  module Enumerators
    module_function

    def eval_binding
      binding
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
  end
end
