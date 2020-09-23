# frozen_string_literal: true

require 'active_support/inflector'

module Arrangement
  class Composer
    include ActiveSupport::Inflector

    def create(schema)
      klass = safe_constantize(classify(schema.keys.first))

      klass.new
    end
  end
end
