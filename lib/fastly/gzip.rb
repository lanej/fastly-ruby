# frozen_string_literal: true
class Fastly::Gzip
  include Fastly::ServiceVersionModel

  # The name of the gzip configuration.
  identity :name

  # The CACHE condition controlling when this gzip configuration applies. This field is optional.
  attribute :cache_condition
  # Space-separated list of content types to compress. If you omit this field a default list will be used.
  attribute :content_types
  # Space-separated list of file extensions to compress. If you omit this field a default list will be used.
  attribute :extensions
  # The alphanumeric string identifying a service.
  attribute :service_id
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_gzip(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def destroy
    requires :service_id, :version_number, :identity

    cistern.destroy_gzip(service_id, version_number, identity)
  end

  def save
    requires :service_id, :version_number, :identity

    response = cistern.update_gzip(service_id, version_number, name, dirty_attributes)
    merge_attributes(response.body)
  end
end
