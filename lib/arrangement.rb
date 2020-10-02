# frozen_string_literal: true

require 'arrangement/errors'
require 'arrangement/generators'
require 'arrangement/composer'
require 'arrangement/schema'
require 'arrangement/version'

##
# TODO: describe this when it actually does something to describe
#
module Arrangement
  module_function

  def fetch(identifier); end

  def new(schema); end

  def create(schema); end

  def add_generator(name, &block)
    Generators.add(name, &block)
  end
end
