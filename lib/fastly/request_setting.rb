# frozen_string_literal: true
class Fastly::RequestSetting
  include Fastly::ServiceVersionModel

  # Name for the request settings.
  identity :name

  # Allows you to terminate request handling and immediately perform an action. When set it can be lookup or pass
  #   [(ignore the cache completely).
  attribute :action
  # Disable collapsed forwarding, so you don't wait for other objects to origin.
  attribute :bypass_busy_wait, type: :boolean
  # Sets the host header.
  attribute :default_host
  # Allows you to force a cache miss for the request. Replaces the item in the cache if the content is cacheable.
  attribute :force_miss, type: :boolean
  # Forces the request use SSL (redirects a non-SSL to SSL).
  attribute :force_ssl, type: :boolean
  # Injects Fastly-Geo-Country, Fastly-Geo-City, and Fastly-Geo-Region into the request headers.
  attribute :geo_headers, type: :boolean
  # Comma separated list of varnish request object fields that should be in the hash key.
  attribute :hash_keys
  # How old an object is allowed to be to serve stale-if-error or stale-while-revalidate.
  attribute :max_stale_age, type: :integer
  # Name of condition object used to test whether or not these settings should be used.
  attribute :condition_name, alias: 'request_condition'
  # The alphanumeric string identifying a service.
  attribute :service_id
  # Injects the X-Timer info into the request for viewing origin fetch durations
  attribute :timer_support, type: :boolean
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'
  # Short for X-Forwarded-For, should be clear, leave, append, append_all, or overwrite.
  attribute :xff

  belongs_to :condition, lambda {
    cistern.conditions(service_id: service_id, version_number: version_number).get(condition_name)
  }

  def save
    requires :service_id, :version_number, :name

    old_name = changed.key?(:name) ? changed[:name].first : name
    response = cistern.update_request_setting(service_id, version_number, old_name, dirty_request_attributes)
    merge_attributes(response.body)
  end

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_request_setting(service_id, version_number, request_attributes)
    merge_attributes(response.body)
  end

  def destroy
    requires :service_id, :version_number, :identity

    cistern.destroy_request_setting(service_id, version_number, identity)
  end
end
