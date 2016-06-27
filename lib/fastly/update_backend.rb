# frozen_string_literal: true
class Fastly::UpdateBackend
  include Fastly::Request

  ACCEPTED_PARAMETERS =
    %w( address auto_loadbalance between_bytes_timeout client_cert comment connect_timeout error_threshold
        first_byte_timeout healthcheck hostname ipv4 ipv6 locked max_conn max_tls_version min_tls_version name port
        request_condition service_id shield ssl_ca_cert ssl_cert_hostname ssl_check_cert ssl_ciphers ssl_client_cert
        ssl_client_key ssl_hostname ssl_sni_hostname use_ssl version weight).freeze

  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/backend/#{r.name}" }
  request_params(&:accepted_attributes)

  parameter :service_id
  parameter :number
  parameter :name
  parameter :attributes

  def mock
    backend = find!(:backends, service_id, number.to_i, name)
    backend.merge!(accepted_attributes.merge('updated_at' => timestamp))

    mock_response(backend)
  end
end
