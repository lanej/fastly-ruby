# frozen_string_literal: true
class Fastly::Gcs < Fastly::Logger
  type :gcs

  # The bucket of the GCS bucket.
  attribute :bucket_name, type: :string
  # The path to upload logs to (default "/").
  attribute :path, type: :string
  # Your GCS account secret key. The private_key field in your service account authentication JSON.
  attribute :secret_key, type: :string
  # Your GCS service account email address. The client_email field in your service account authentication JSON.
  attribute :user, type: :string
end
