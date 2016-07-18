# frozen_string_literal: true
ENV['MOCK_FASTLY'] ||= 'true'

Bundler.require(:test)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fastly'

Dir[File.expand_path('../{support,shared,matchers,fixtures}/*.rb', __FILE__)].each { |f| require(f) }

Fastly.mock! if ENV['MOCK_FASTLY'] == 'true'

RSpec.configure do |config|
  if Fastly.mocking?
    config.before(:each) { Fastly.reset! }
    config.filter_run_excluding(real: true)
  else
    config.filter_run_excluding(mock: true)
  end
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true

  config.order = 'random'
end
