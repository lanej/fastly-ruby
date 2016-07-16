# frozen_string_literal: true
class Fastly::Logentries < Fastly::Logger

  type :logentries

  # The port number.
  attribute :port, type: :integer
  # Use token based authentication (https://logentries.com/doc/input-token/).
  attribute :token, type: :string
  # Whether to use TLS for secure logging.
  attribute :use_tls, type: :boolean
end
