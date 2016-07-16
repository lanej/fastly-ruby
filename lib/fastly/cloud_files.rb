# frozen_string_literal: true
class Fastly::CloudFiles < Fastly::Logger

  type :cloudfiles

  # Your Cloudfile account access key.
  attribute :access_key, type: :string
  # The name of your Cloudfiles container.
  attribute :bucket_name, type: :string
  # The path to upload logs to.
  attribute :path, type: :string
  # The username for your Cloudfile account.
  attribute :user, type: :string

end
