# frozen_string_literal: true
class Fastly::Settings
  include Fastly::Singular

  # The default host name for the version.
  attribute :default_host, alias: 'general.default_host'
  # The default Time-to-live (TTL) for the version.
  attribute :default_ttl, type: :integer, alias: 'general.default_ttl'
  # The alphanumeric string identifying a service.
  attribute :service_id
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def save
    requires :service_id, :version_number

    response = cistern.update_settings(service_id, version_number, dirty_request_attributes)

    merge_attributes(response.body)
  end

  def get
    merge_attributes(cistern.get_settings(service_id, version_number).body)
  end
end
