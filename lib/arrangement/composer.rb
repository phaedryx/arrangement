# frozen_string_literal: true

require 'active_support/inflector'

module Arrangement
  ##
  # TODO: describe this when it is more fleshed out
  #
  class Composer
    include ActiveSupport::Inflector

    attr_reader :defaults

    def initialize(schemas_directory_path: nil)
      @defaults = load_and_merge_schemas(schemas_directory_path)
    end

    def load_and_merge_schemas(schemas_directory_path)
      schema = Schema.new

      return schema unless schemas_directory_path

      schema_files = Dir["#{schemas_directory_path}/**/*_schema.yml"]
      schema_files.each { |file| schema = schema.merge(Schema.load_file(file)) }

      schema
    end

    def create(schema)
      klass = safe_constantize(classify(schema.keys.first))

      klass.new
    end
  end
end
