# frozen_string_literal: true
class Fastly::CreateService
  include Fastly::Request
  request_method :post
  request_path { |_r| '/service' }
  request_params { |r| { 'name' => r.name } }

  parameter :name

  def mock
    service_id = cistern.new_id

    new_service = {
      'id'          => service_id,
      'name'        => name,
      'customer_id' => cistern.current_customer.identity,
      'comment'     => '',
      'publish_key' => cistern.new_id,
      'created_at'  => timestamp,
      'updated_at'  => timestamp,
    }

    version = {
      'number'     => '1',
      'backend'    => 0,
      'service_id' => service_id,
      'testing'    => nil,
      'staging'    => nil,
      'locked'     => '0',
      'active'     => nil,
      'deployed'   => nil,
      'comment'    => '',
      'deleted_at' => nil,
      'service'    => service_id,
      'created_at' => timestamp,
      'updated_at' => timestamp,
    }

    cistern.data[:service_versions][service_id][1] = version
    cistern.data[:services][service_id] = new_service
    cistern.data[:settings][service_id][1] = { 'general.default_host' => '', 'general.default_ttl' => 3600 }

    mock_response(new_service.merge('versions' => [version]))
  end
end
