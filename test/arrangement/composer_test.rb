# frozen_string_literal: true

require 'test_helper'
require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table(:users) do |t|
    t.string :first_name
    t.string :last_name
  end
end

ActiveRecord::Schema.define do
  create_table(:widgets) do |t|
    t.integer :user_id
    t.boolean :runcible
    t.string  :color
    t.decimal :size
    t.text    :description
  end
end

class User < ActiveRecord::Base
  has_many :widgets
end

class Widget < ActiveRecord::Base
  belongs_to :user
end

describe Arrangement::Composer do
  describe '#new' do
    it 'should load default schemas' do
      composer = Arrangement::Composer.new(schemas_directory_path: 'test/schemas')

      assert composer.defaults.is_a?(Arrangement::Schema)

      assert_equal(
        { id: 1, first_name: 'BobA', last_name: 'Jones' },
        composer.defaults[:user].to_h
      )
      assert_equal(
        { id: 2, first_name: 'BobB', last_name: 'Jones' },
        composer.defaults[:user].to_h
      )

      assert_equal(1, composer.defaults[:widget].to_h[:id])
      assert_equal(2, composer.defaults[:widget].to_h[:id])
    end
  end

  describe '#create' do
    it 'creates a top-level object' do
      composer = Arrangement::Composer.new
      user = composer.create(user: {})

      assert user.is_a?(User)
    end
  end
end
