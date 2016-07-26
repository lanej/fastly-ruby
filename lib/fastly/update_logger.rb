# frozen_string_literal: true
class Fastly::UpdateLogger
  include Fastly::Request

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/logging/#{r.type}/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id, :number, :type, :name, :attributes

  def accepted_attributes
    Cistern::Hash.except(Cistern::Hash.stringify_keys(attributes), 'type')
  end

  def mock
    logger = find!(:loggers, service_id, number.to_i, name)
    logger.merge!(accepted_attributes.merge('updated_at' => timestamp))

    mock_response(logger)
  end
end
