# frozen_string_literal: true
class Fastly::UpdateRequestSetting
  include Fastly::Request

  ACCEPTED_PARAMETERS = %w( action bypass_busy_wait default_host force_miss force_ssl geo_headers hash_keys
                            max_stale_age condition_name timer_support xff name ).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/request_settings/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    request_setting = find!(:request_settings, service_id, number.to_i, name)

    updated = request_setting.merge(accepted_attributes)

    updated.merge!(accepted_attributes.merge('updated_at' => timestamp))
    new_name = updated['name']

    parent = find!(:request_settings, service_id, number.to_i)
    parent.delete(name)
    parent[new_name] = updated

    mock_response(updated)
  end
end
