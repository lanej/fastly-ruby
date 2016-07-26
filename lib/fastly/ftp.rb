# frozen_string_literal: true
class Fastly::Ftp < Fastly::Logger
  type :ftp

  # An hostname or IPv4 address.
  attribute :address, type: :string
  # Hostname used.
  attribute :hostname, type: :string
  # IPv4 address of the host.
  attribute :ipv4, type: :string
  # The password for the server (for anonymous use an email address).
  attribute :password, type: :string
  # The path to upload log files to. If the path ends in / then it is treated as a directory.
  attribute :path, type: :string
  # The port number.
  attribute :port, type: :integer
  # The username for the server (can be anonymous).
  attribute :user, type: :string
end
