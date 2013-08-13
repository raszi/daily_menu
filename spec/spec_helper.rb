require 'simplecov'
SimpleCov.start

require 'daily_menu'
require 'vcr'

VCR.configure do |conf|
  conf.cassette_library_dir = 'fixtures/vcr_cassettes'
  conf.hook_into :faraday
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
