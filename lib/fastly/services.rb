# frozen_string_literal: true
class Fastly::Services
  include Fastly::Collection

  model Fastly::Service

  def all(options = {})
    resources = if options.empty?
                  cistern.get_services.body
                else
                  [cistern.search_services(options).body]
                end

    load(resources)
  end

  def get!(identity)
    new(
      cistern.get_service(identity).body
    )
  end

  def get(identity)
    get!(identity)
  rescue Fastly::Response::BadRequest
    nil
  end
end
