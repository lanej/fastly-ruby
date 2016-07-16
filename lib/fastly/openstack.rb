# frozen_string_literal: true
class Fastly::Openstack < Fastly::Logger

  type :openstack

  # Your OpenStack account access key.
  attribute :access_key, type: :string
  # The name of your OpenStack container.
  attribute :bucket_name, type: :string
  # The path to upload logs to.
  attribute :path, type: :string
  # Your OpenStack auth url.
  attribute :url, type: :string
  # The username for your OpenStack account.
  attribute :user, type: :string
end
