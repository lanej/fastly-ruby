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

    receiver.belongs_to :service, -> { cistern.services.get(service_id) }
    receiver.belongs_to :version, -> { cistern.versions(service_id: service_id).get(version_number) }
  end
end
