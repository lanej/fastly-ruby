# frozen_string_literal: true
class Fastly::ResponseObject
  include Fastly::ServiceVersionModel

  # Name that identifies the Response Object.
  identity :name

  # Name of the condition checked after we have retrieved an object. If the condition passes then deliver this Request
  #   Object instead.
  attribute :cache_condition_name, alias: 'cache_condition'
  # The content to deliver for the response object, can be empty.
  attribute :content
  # The MIME type of the content, can be empty.
  attribute :content_type
  # The alphanumeric string identifying a service.
  attribute :service_id
  # The HTTP Status Code, defaults to 200.
  attribute :status
  # The HTTP Response, defaults to "Ok"
  attribute :response
  # Name of the condition to be checked during the request phase. If the condition passes then this object will be
  #   delivered.
  attribute :request_condition_name, alias: 'request_condition'
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  belongs_to :cache_condition, lambda {
    cistern.conditions(service_id: service_id, version_number: version_number).get(cache_condition_name)
  }

  belongs_to :request_condition, lambda {
    cistern.conditions(service_id: service_id, version_number: version_number).get(request_condition_name)
  }

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_response_object(service_id, version_number, request_attributes)
    merge_attributes(response.body)
  end

  def save
    requires :service_id, :version_number, :name

    old_name = changed.key?(:name) ? changed[:name].first : name
    response = cistern.update_response_object(service_id, version_number, old_name, dirty_attributes)
    merge_attributes(response.body)
  end
end
