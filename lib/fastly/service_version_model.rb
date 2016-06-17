# frozen_string_literal: true
module Fastly::ServiceVersionModel
  attr_reader :cistern

  class << self
    alias orig_included included
  end

  def self.included(receiver)
    orig_included(receiver)
    receiver.include(Fastly::Model)
    super
  end

  def service
    @_service ||= begin
                    requires :service_id

                    cistern.services.get(service_id)
                  end
  end

  def version
    @_version ||= begin
                    requires :service_id, :version_number

                    cistern.versions(service_id: service_id).get(version_number)
                  end
  end
end
