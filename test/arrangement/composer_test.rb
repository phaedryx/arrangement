# frozen_string_literal: true

require 'test_helper'
require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table(:users) do |t|
    t.string  :first_name
    t.string  :last_name
  end
end

class User < ActiveRecord::Base; end

describe Arrangement::Composer do
  describe '#create' do
    it 'creates a top-level object' do
      composer = Arrangement::Composer.new
      user = composer.create(user: {})

      assert user.is_a?(User)
    end
  end
end
