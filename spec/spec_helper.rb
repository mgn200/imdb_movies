require './movie_collection'
require './theatre.rb'
require './netflix.rb'
require './movie.rb'
require './classic_movie.rb'
require './ancient_movie.rb'
require './modern_movie.rb'
require './new_movie.rb'
require 'factory_girl'
require 'timecop'
require 'money'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
