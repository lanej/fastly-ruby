# frozen_string_literal: true
module Fastly::ServiceVersionModel
  attr_reader :cistern

  def self.included(receiver)
    receiver.include(Fastly::Model)

    receiver.belongs_to :service, -> { cistern.services.get(service_id) }
    receiver.belongs_to :version, -> { cistern.versions(service_id: service_id).get(version_number) }

    receiver.include(ServiceVersionCollection)

    super
  end

  module ServiceVersionCollection
    def collection
      ret = super
      ret.service_id ||= service_id
      ret.version_number ||= version_number
      ret
    end

    def reload
      requires :service_id, :version_number, :identity

      latest = collection.get(identity)
      merge_attributes(latest.attributes) if latest
    end
  end
end
