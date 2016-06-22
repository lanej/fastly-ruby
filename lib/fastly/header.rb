# frozen_string_literal: true
class Fastly::Header
  include Fastly::ServiceVersionModel

  # A handle to refer to this Header object
  identity :name

  # Accepts a string value, one of:
  #   set - Sets (or resets) a header
  #   append - Appends to an existing header
  #   delete - Delete a header
  #   regex - Perform a single regex replacement on a header
  #   regex_repeat - Perform a global regex replacement on a header
  attribute :action, type: :string
  # Optional name of a CacheCondition to apply.
  attribute :cache_condition
  # Header to set.
  attribute :dst
  # Don't add the header if it is added already. (Only applies to 'set' action)
  attribute :ignore_if_set, type: :integer
  # Lower priorities execute first. (Default: 100.)
  attribute :priority, type: :integer
  # Regular expression to use (Only applies to 'regex' and 'regex_repeat' actions).
  attribute :regex
  # Optional name of a RequestCondition to apply.
  attribute :request_condition
  # Optional name of a ResponseCondition to apply.
  attribute :response_condition
  # The alphanumeric string identifying a service.
  attribute :service_id
  # Variable to be used as a source for the header content. (Does not apply to 'delete' action)
  attribute :src
  # Accepts a string value, one of:
  #   request - Performs on the request before lookup occurs
  #   fetch - Performs on the request to the origin server
  #   cache - Performs on the response before it's stored in the cache
  #   response - Performs on the response before delivering to the client
  attribute :type, type: :string
  # Value to substitute in place of regular expression. (Only applies to 'regex' and 'regex_repeat')
  attribute :substitution
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def create
    requires :service_id, :version_number, :name, :type

    response = cistern.create_header(service_id, version_number, attributes)
    merge_attributes(response.body)
  end
end
