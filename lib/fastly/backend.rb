# frozen_string_literal: true
class Fastly::Backend
  include Fastly::Model
  include Fastly::ServiceVersionModel

  identity :id, alias: 'name'

  # An hostname, IPv4, or IPv6 address for the backend.
  attribute :address
  # Whether or not this backend should be automatically load balanced.
  attribute :auto_loadbalance, type: :boolean
  # How long to wait between bytes in milliseconds.
  attribute :between_bytes_timeout, type: :integer
  # A comment.
  attribute :comment
  # How long to wait for a timeout in milliseconds.
  attribute :connect_timeout, type: :integer
  # Number of errors to allow before the backend is marked as down.
  attribute :error_threshold, type: :integer
  # How long to wait for the first bytes in milliseconds.
  attribute :first_byte_timeout, type: :integer
  # The name of the healthcheck to use with this backend. Can be empty.
  attribute :healthcheck
  # The hostname of the backend.
  attribute :hostname
  # IPv4 address of the host.
  attribute :ipv4
  # IPv6 address of the host.
  attribute :ipv6
  # Specifies whether or not the version is locked for editing.
  attribute :locked, type: :boolean
  # Maximum number of connections.
  attribute :max_conn, type: :integer
  # Maximum allowed TLS version on SSL connections to this backend.
  attribute :max_tls_version, type: :integer
  # Minimum allowed TLS version on SSL connections to this backend.
  attribute :min_tls_version, type: :integer
  # The name of the backend.
  attribute :name
  # The port number.
  attribute :port, type: :integer
  # Condition, which if met, will select this backend during a request.
  attribute :request_condition
  # The alphanumeric string identifying a service.
  attribute :service_id
  # The shield POP designated to reduce inbound load on this origin by serving the cached data to the rest of the
  #   network.
  attribute :shield
  # CA certificate attached to origin.
  attribute :ssl_ca_cert
  # Overrides ssl_hostname, but only for cert verification. Does not affect SNI at all.
  attribute :ssl_cert_hostname
  # Be strict on checking SSL certs.
  attribute :ssl_check_cert, type: :boolean
  # List of OpenSSL ciphers (see https://www.openssl.org/docs/manmaster/apps/ciphers.html for details)
  attribute :ssl_ciphers
  # Client certificate attached to origin.
  attribute :ssl_client_cert
  # Client key attached to origin.
  attribute :ssl_client_key
  # Used for both SNI during the TLS handshake and to validate the cert.
  attribute :ssl_hostname
  # Overrides ssl_hostname, but only for SNI in the handshake. Does not affect cert validation at all.
  attribute :ssl_sni_hostname
  # Whether or not to use SSL to reach the backend.
  attribute :use_ssl, type: :boolean
  # The current version number of a service.
  attribute :version_number, type: :integer, alias: 'version'
  # Weight used to load balance this backend against others.
  attribute :weight, type: :integer

  def create
    requires :service_id, :version_number, :name

    requires_one :address, :ipv4, :ipv6, :hostname

    response = cistern.create_backend(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def destroy
    requires :service_id, :version_number, :identity

    cistern.destroy_backend(service_id, version_number, identity)
  end

  def reload
    requires :service_id, :version_number, :identity

    @_service = nil
    @_version = nil

    latest = cistern.backends(service_id: service_id, version_number: version_number).get(identity)
    merge_attributes(latest.attributes) if latest
  end

  def save
    requires :service_id, :version_number, :identity

    response = cistern.update_backend(service_id, version_number, name, attributes)
    merge_attributes(response.body)
  end
end
