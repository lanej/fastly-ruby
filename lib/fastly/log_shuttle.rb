# frozen_string_literal: true
class Fastly::LogShuttle < Fastly::Logger
  type :logshuttle

  # The data authentication token associated with this endpoint.
  attribute :token, type: :string
  # Your Log Shuttle endpoint url.
  attribute :url, type: :string
end
