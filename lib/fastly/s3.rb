# frozen_string_literal: true
class Fastly::S3 < Fastly::Logger

  type :s3

  # Your S3 account access key.
  attribute :access_key
  # The bucket name for S3 account.
  attribute :bucket_name
  # The domain of the Amazon S3 endpoint.
  attribute :domain
  # Apache style log formatting.
  attribute :format
  attribute :format_version
  # The path to upload logs to.
  attribute :path
  # The S3 redundancy level.
  attribute :redundancy
  # When to execute the s3. If empty, always execute.
  attribute :response_condition
  # Your S3 account secret key.
  attribute :secret_key
  # Optional server-side KMS Key Id. Must be set if server_side_encryption is set to aws:kms
  attribute :server_side_encryption_kms_key_id
  # String Set this to AES256 or aws:kms to enable S3 Server Side Encryption.
  attribute :server_side_encryption
end
