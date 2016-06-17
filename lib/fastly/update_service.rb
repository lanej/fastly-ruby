# frozen_string_literal: true
class Fastly::UpdateService
  include Fastly::Request

  def self.accepted_parameters
    %w(name comment)
  end

  request_method :put
  request_path { |r| "/service/#{r.service_id}" }
  request_params(&:updated_attributes)

  parameter :service_id
  parameter :attributes

  def updated_attributes
    Cistern::Hash.slice(Cistern::Hash.stringify_keys(attributes), *self.class.accepted_parameters)
  end

  def mock
    resource = find!(:services, service_id)
    resource.merge!(request_params)

    mock_response(resource)
  end
end
