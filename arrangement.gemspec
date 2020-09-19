# frozen_string_literal: true

require_relative 'lib/arrangement/version'

Gem::Specification.new do |spec|
  spec.name        = 'arrangement'
  spec.version     = Arrangement::VERSION
  spec.authors     = ['Tad Thorley']
  spec.email       = ['phaedryx@gmail.com']
  spec.summary     = 'An easy way to follow the "Arrange, Act, Assert" pattern in your Ruby on Rails tests'
  spec.description = 'An easy way to follow the "Arrange, Act, Assert" pattern in your Ruby on Rails tests'
  spec.homepage    = 'https://github.com/phaedryx/arrangement'
  spec.license     = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/phaedryx/arrangement'
  spec.metadata['changelog_uri']     = 'https://github.com/phaedryx/arrangement'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
end
