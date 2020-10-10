# frozen_string_literal: true

require 'test_helper'

describe Arrangement::Schema do
  def incrementer
    Arrangement::Generators.incrementer
  end

  describe '#call_value' do
    it 'should return what it is given if not callable' do
      schema = Arrangement::Schema.new
      value = 1

      assert_equal 1, schema.call_value(value)
      assert_equal 1, schema.call_value(value)
    end

    it 'should return the result of the call if callable' do
      schema = Arrangement::Schema.new
      value = incrementer

      assert_equal 1, schema.call_value(value)
      assert_equal 2, schema.call_value(value)
    end
  end

  describe '#call_collect' do
    it 'should change callable values in collections' do
      schema = Arrangement::Schema.new
      hash = { foo: 'bar', callable: incrementer }

      assert_equal({ foo: 'bar', callable: 1 }, schema.call_collect(hash))
      assert_equal({ foo: 'bar', callable: 2 }, schema.call_collect(hash))
    end

    it 'should handle nested hashes' do
      schema = Arrangement::Schema.new
      hash = { foo: { bar: { baz: incrementer } } }

      assert_equal({ foo: { bar: { baz: 1 } } }, schema.call_collect(hash))
      assert_equal({ foo: { bar: { baz: 2 } } }, schema.call_collect(hash))
    end

    it 'should handle nested arrays' do
      schema = Arrangement::Schema.new
      hash = { foo: [incrementer, incrementer] }

      assert_equal({ foo: [1, 1] }, schema.call_collect(hash))
      assert_equal({ foo: [2, 2] }, schema.call_collect(hash))
    end

    it 'should handle hashes mixed with arrays' do
      schema = Arrangement::Schema.new
      hash = { foo: [{ bar: incrementer }, { baz: { qux: incrementer } }] }

      assert_equal({ foo: [{ bar: 1 }, { baz: { qux: 1 } }] }, schema.call_collect(hash))
      assert_equal({ foo: [{ bar: 2 }, { baz: { qux: 2 } }] }, schema.call_collect(hash))
    end
  end

  describe '#[]' do
    it 'should return the result of the value if key holds a callable' do
      schema = Arrangement::Schema.new
      schema[:id] = incrementer

      assert_equal 1, schema[:id]
      assert_equal 2, schema[:id]
    end
  end

  describe '#fetch' do
    it 'should return the result of the value if key holds a callable' do
      schema = Arrangement::Schema.new
      schema[:id] = incrementer

      assert_equal 1, schema.fetch(:id)
      assert_equal 2, schema.fetch(:id)
    end
  end

  describe '#to_h' do
    it 'should return a hash with the call result of values' do
      schema = Arrangement::Schema.new
      schema[:id] = incrementer

      assert_equal({ id: 1 }, schema.to_h)
      assert_equal({ id: 2 }, schema.to_h)
    end
  end

  describe '#merge' do
    it 'should preserve callables when merging' do
      schema = Arrangement::Schema.new
      user = Arrangement::Schema.new
      widget = Arrangement::Schema.new

      user[:user] = incrementer
      widget[:widget] = incrementer
      schema = schema.merge(user.merge(widget))

      assert_equal({ user: 1, widget: 1 }, schema.to_h)
    end
  end

  describe '.load' do
    it 'should take a nested yaml-like string and return a schema' do
      schema = Arrangement::Schema.load <<~YAML
        foo:
          bar: <= incrementer(1,1)
          baz:
            - <= incrementer(2,2)
            - <= incrementer(3,3)
      YAML
      assert_equal({ foo: { bar: 1, baz: [2, 3] } }, schema.to_h)
      assert_equal({ foo: { bar: 2, baz: [4, 6] } }, schema.to_h)
      assert_equal({ foo: { bar: 3, baz: [6, 9] } }, schema.to_h)
    end

    it 'should be a schema at every level of nesting' do
      schema = Arrangement::Schema.load <<~YAML
        foo:
          bar:
            baz:
              qux:
      YAML

      assert_equal Arrangement::Schema, schema.class
      assert_equal Arrangement::Schema, schema[:foo].class
      assert_equal Arrangement::Schema, schema[:foo][:bar][:baz].class
    end
  end

  describe '.load_file' do
    it 'should take a yaml file and return a schema' do
      schema = Arrangement::Schema.load_file('./test/schemas/test.yml')

      assert_equal({ id: 10, first_name: 'Tony', last_name: 'Stark' }, schema.to_h)
      assert_equal({ id: 15, first_name: 'Tony', last_name: 'Stark' }, schema.to_h)
    end

    it 'should return an empty schema for an empty file' do
      schema = Arrangement::Schema.load_file('./test/schemas/empty.yml')

      assert schema.empty?
    end
  end
end
