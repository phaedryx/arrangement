# frozen_string_literal: true

require 'test_helper'

describe Arrangement::Generators do
  describe '#add' do
    it 'adds a generator to the generators' do
      Arrangement::Generators.add(:phone) do
        incr = string_incrementer('801-555-0000')
        -> { incr.call }
      end

      phone = Arrangement::Generators.phone

      assert_equal('801-555-0000', phone.call)
      assert_equal('801-555-0001', phone.call)
      assert_equal('801-555-0002', phone.call)
    end
  end
end
