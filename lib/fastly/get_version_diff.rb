# frozen_string_literal: true
class Fastly::GetVersionDiff
  include Fastly::Request

  request_method :get
  request_path { |r| "/service/#{r.service_id}/diff/from/#{r.from}/to/#{r.to}" }

  parameter :service_id, :from, :to, :format

  MOCK_DIFF = <<-'YAML-ISH'.strip
       backends:
 - name: My Backend
   address: backend.example.com
   auto_loadbalance: '0'
   between_bytes_timeout: 10000
   client_cert:
   comment: ''
   connect_timeout: 1000
   error_threshold: 0
   first_byte_timeout: 15000
   healthcheck:
   hostname: www.example.com
   ipv4:
   ipv6:
   max_conn: 200
   port: 80
   request_condition: ''
   shield:
   ssl_ca_cert:
   ssl_client_cert:
   ssl_client_key:
   ssl_hostname:
   use_ssl: false
   weight: 100
 cache_settings: []
 comment: ''
 conditions: []
 deployed:
 directors: []
 domains:
 - name: www.example.com
   comment: ''
 gzips: []
-headers: []
+headers:
+- name: Debug
+  action: set
+  cache_condition:
+  dst: http.X-Test
+  ignore_if_set: '0'
+  priority: '10'
+  regex: ''
+  request_condition:
+  response_condition:
+  src: '"testing"'
+  substitution: ''
+  type: request
 healthchecks: []
 matches: []
 origins: []
 request_settings: []
 response_objects: []
 service_id: SU1Z0isxPaozGVKXdv0eY
 settings:
   general.default_host: ''
   general.default_ttl: 3600
 staging:
 syslogs: []
 testing:
 vcls: []
 wordpress: []
}
      YAML-ISH

  def mock
    mock_response(
      'from'   => from,
      'to'     => to,
      'format' => format,
      'diff'   => MOCK_DIFF,
    )
  end
end
