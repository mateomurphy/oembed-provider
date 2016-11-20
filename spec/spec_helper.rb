require 'rubygems'
require 'bundler'

Bundler.require

require 'vcr'
require 'rack/test'
require 'dotenv'

Dotenv.load

require_relative '../app'

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<CLIENT_ID>') { ENV['UNSPLASH_APPLICATION_ID'] }
end

RSpec.configure do |config|

  config.include Rack::Test::Methods

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random

  Kernel.srand config.seed
end
