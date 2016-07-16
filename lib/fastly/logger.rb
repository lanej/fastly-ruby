# frozen_string_literal: true
class Fastly::Logger
  include Fastly::ServiceVersionModel

  def self.for(type)
    types.fetch(type.to_sym)
  end

  def self.types
    @types ||= {}
  end

  def self.type(type=nil)
    if type.nil?
      @type
    else
      Fastly::Loggers.add_type(type.to_sym)
      Fastly::Logger.types[type.to_sym] = self
      (@type = type)
    end
  end

  def type
    self.class.type
  end

  identity :name

  # Time-stamp (GMT) when the endpoint was created.
  attribute :created_at, type: :time
  # Time-stamp (GMT) when the endpoint was deleted.
  attribute :deleted_at, type: :time
  # What level of GZIP encoding to have when dumping logs (default 0, no compression).
  attribute :gzip_level, type: :integer
  attribute :message_type
  # How frequently the logs should be dumped (in seconds, default 3600).
  attribute :period, type: :integer
  # The alphanumeric string identifying a service.
  attribute :service_id
  # strftime specified timestamp formatting (default "%Y-%m-%dT%H:%M:%S.000").
  attribute :timestamp_format
  # Time-stamp (GMT) when the endpoint was deleted.
  attribute :updated_at, type: :time
  # The current version of a service.
  attribute :version_number, type: :integer, alias: 'version'

  def create
    requirements = requires :service_id, :version_number, :type, :name

    response = cistern.create_logger(*requirements.values, attributes)
    merge_attributes(response.body)
  end

  def save
    requirements = requires :service_id, :version_number, :type, :name

    response = cistern.update_logger(*requirements.values, attributes)
    merge_attributes(response.body)
  end

  def destroy
    requirements = requires :service_id, :version_number, :type, :name

    cistern.destroy_logger(*requirements.values)
  end
end

require 'fastly/loggers'
require 'fastly/s3'
