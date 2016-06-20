# frozen_string_literal: true
class Fastly::DestroyDictionary
  include Fastly::Request

  request_method :delete
  request_path { |r| "/service/#{r.service_id}/version/#{r.version_number}/dictionary/#{r.name}" }

  parameter :service_id
  parameter :version_number
  parameter :name

  def mock
    delete!(:dictionaries, service_id, version_number, name)
  end
end
