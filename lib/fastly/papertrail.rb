# frozen_string_literal: true
class Fastly::Papertrail < Fastly::Logger
  type :papertrail

  # An hostname or IPv4 address.
  attribute :address, type: :string
  # The port number.
  attribute :port, type: :integer
end
