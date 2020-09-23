# frozen_string_literal: true

require_relative 'lib/arrangement/version'

Gem::Specification.new do |spec|
  spec.name        = 'arrangement'
  spec.version     = Arrangement::VERSION
  spec.authors     = ['Tad Thorley']
  spec.email       = ['phaedryx@gmail.com']
  spec.summary     = 'An easy way to make arrangements for the "Arrange, Act, Assert" pattern'
  spec.description = 'An easy way to follow the "Arrange, Act, Assert" pattern in your Ruby on Rails tests'
  spec.homepage    = 'https://github.com/phaedryx/arrangement'
  spec.license     = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/phaedryx/arrangement'
  spec.metadata['changelog_uri']     = 'https://github.com/phaedryx/arrangement'

  spec.add_dependency 'activerecord', '~> 6.0'
  spec.add_dependency 'railties', '~> 6.0'

  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'minitest-focus', '~> 1.2'
  spec.add_development_dependency 'pry', '~> 0.13'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 0.91.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
  spec.add_development_dependency 'yard', '~> 0.9.25'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  spec.require_paths = ['lib']
  spec.files = `git ls-files -- lib/*`.split("\n") + %w[README.md LICENSE.txt]
end
