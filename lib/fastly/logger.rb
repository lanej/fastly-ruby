# frozen_string_literal: true
class Fastly::Logger
  include Fastly::ServiceVersionModel

  def self.for(type)
    types.fetch(type.to_s)
  end

  def self.types
    @types ||= {}
  end

  def self.type(type = nil)
    if type.nil?
      @type
    else
      (@type = type.to_s)
      Fastly::Loggers.add_type(@type)
      raise ArgumentError, "already defined: #{@type}" if Fastly::Logger.types[@type]
      Fastly::Logger.types[@type] = self
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
  # Apache style log formatting (default (defaults to '%h %l %u %t "%r" %>s %b').
  attribute :format, type: :string
  attribute :format_version, type: :integer
  # What level of GZIP encoding to have when dumping logs (default 0, no compression).
  attribute :gzip_level, type: :integer
  attribute :message_type
  # How frequently the logs should be dumped (in seconds, default 3600).
  attribute :period, type: :integer
  # When to execute the GCS logging rule. If empty, always execute.
  attribute :response_condition, type: :string
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

require 'fastly/cloud_files'
require 'fastly/ftp'
require 'fastly/gcs'
require 'fastly/log_shuttle'
require 'fastly/logentries'
require 'fastly/openstack'
require 'fastly/papertrail'
require 'fastly/s3'
require 'fastly/sumo_logic'
require 'fastly/syslog'
