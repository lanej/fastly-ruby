# frozen_string_literal: true
class Fastly::Healthcheck
  include Fastly::ServiceVersionModel

  # The name of the healthcheck.
  identity :name

  # How often to run the healthcheck in milliseconds.
  attribute :check_interval, type: :integer
  # A comment.
  attribute :comment
  # The status code expected from the host.
  attribute :expected_response, type: :integer
  # Which host to check.
  attribute :host
  # Whether to use version 1.0 or 1.1 HTTP.
  attribute :http_version, type: :integer
  # When loading a config, the initial number of probes to be seen as OK.
  attribute :initial, type: :integer
  # Which HTTP method to use.
  attribute :method
  # The path to check.
  attribute :path
  # The alphanumeric string identifying a service.
  attribute :service_id
  # How many healthchecks must succeed to be considered healthy.
  attribute :threshold, type: :integer
  # Timeout in milliseconds.
  attribute :timeout, type: :integer
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'
  # The number of most recent healthcheck queries to keep for this healthcheck.
  attribute :window, type: :integer

  def create
    requires :service_id, :version_number, :name, :host, :path

    response = cistern.create_healthcheck(service_id, version_number, attributes)
    merge_attributes(response.body)
  end
end
