# frozen_string_literal: true
class Fastly::Customer
  include Fastly::Model

  identity :id

  attribute :api_key, alias: 'raw_api_key'
  attribute :billing_contact_id
  attribute :can_configure_wordpress, type: :boolean # Whether this customer can edit wordpress. Read Only.
  attribute :can_reset_passwords,     type: :boolean # Whether this customer can reset passwords. Read Only.
  attribute :can_stream_syslog,       type: :boolean # Whether this customer can stream syslogs. Read Only.
  attribute :can_upload_vcl,          type: :boolean # Whether this customer can upload VCL. Read Only.
  attribute :created_at,              type: :time
  attribute :has_config_panel,        type: :boolean # Whether this customer has a configuration panel. Read Only.
  attribute :name                                    # The name of the customer, generally the company name.
  attribute :owner_id
  attribute :pricing_plan                            # The pricing plan this customer is under.
  attribute :updated_at, type: :time
end
