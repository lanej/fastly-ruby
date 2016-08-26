# frozen_string_literal: true
class Fastly::Diff
  include Fastly::Singular

  attribute :from, type: :integer
  attribute :to,   type: :integer
  attribute :format, default: 'text'
  attribute :service_id
  attribute :diff, type: :string

  belongs_to :from_version, ->() { cistern.versions(service_id: service_id).get(from) }
  belongs_to :to_version, ->() { cistern.versions(service_id: service_id).get(to) }

  def get
    requires :service_id, :from, :to, :format

    data = cistern.get_version_diff(service_id, from, to, format).body

    merge_attributes(data)
  end

  def from_version=(version)
    super
    merge_attributes(from: attributes[:from_version][:number])
  end

  def to_version=(version)
    super
    merge_attributes(to: attributes[:to_version][:number])
  end
end
