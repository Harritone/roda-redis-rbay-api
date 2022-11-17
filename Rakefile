# frozen_string_literal: true

# Rakefile contains all the application-related tasks.

require_relative './system/application'

# Enable database component.
Application.start(:database)

# Enable logger componnent.
Application.start(:logger)

namespace :db do
  desc 'Seed redis with test data.'
  task :seed do
    sh %(ruby db/seeds.rb)
  end
end
