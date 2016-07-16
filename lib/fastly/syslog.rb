# frozen_string_literal: true
class Fastly::Syslog < Fastly::Logger

  type :syslog

  # A hostname or IPv4 address.
  attribute :address, type: :string
  # The hostname used for the syslog endpoint.
  attribute :hostname, type: :string
  # The IPv4 address used for the syslog endpoint.
  attribute :ipv4, type: :string
  # The port number.
  attribute :port, type: :integer
  # A secure certificate to authenticate the server with.
  attribute :tls_ca_cert, type: :string
  # Used during the TLS handshake to validate the certificate.
  attribute :tls_hostname, type: :string
  # Whether to prepend each message with a specific token.
  attribute :token, type: :string
  # Whether to use TLS for secure logging.
  attribute :use_tls, type: :boolean

end
