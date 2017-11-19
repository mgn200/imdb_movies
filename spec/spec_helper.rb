require 'imdb_playfield'
require 'webmock/rspec'
require 'vcr'
require 'rspec-html-matchers'
require 'timecop'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
  #imdb, файлы на компе сохраняются в первый раз и затем юзаются
  #в use_cassette не работает, почему?
  c.ignore_hosts 'http://imdb.com/title/'
end

RSpec.configure do |config|
  include ImdbPlayfield::TimeHelper
  WebMock.disable_net_connect!(allow_localhost: true)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  include RSpecHtmlMatchers
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
