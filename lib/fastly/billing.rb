# frozen_string_literal: true
class Fastly::Billing
  include Fastly::Model

  identity :id, alias: 'invoice_id'

  # The end date of this invoice.
  attribute :end_time
  # The alphanumeric string identifying the specified invoice.
  attribute :invoice_id
  # The start date of this invoice.
  attribute :start_time
  # When the invoice was sent out (if Outstanding or Paid)
  attribute :'status.sent_at'
  # What the current status of this invoice can be. One of Pending (being generated), Outstanding (unpaid),
  #   Paid (paid), Month to date (the current month)
  attribute :'status.status'
  # The total amount of bandwidth used this month (See bandwidth_units for measurement).
  attribute :'total.bandwidth', type: :integer
  # The cost of the bandwidth used this month in USD.
  attribute :'total.bandwidth_cost', type: :integer
  # Bandwidth measurement units based on billing plan. Ex: GB
  attribute :'total.bandwidth_units'
  # The final amount to be paid.
  attribute :'total.cost', type: :integer
  # Total incurred cost plus extras cost.
  attribute :'total.cost_before_discount', type: :integer
  # Calculated discount rate.
  attribute :'total.discount', type: :integer
  # A list of any extras for this invoice.
  attribute :'total.extras'
  # Total cost of all extras.
  attribute :'total.extras_cost', type: :integer
  # The name of this extra cost
  attribute :'total.extras.name'
  # Recurring monthly cost in USD (not present if $0.0).
  attribute :'total.extras.recurring', type: :integer
  # Initial set up cost in USD (not present if $0.0 or this is not the month the extra was added).
  attribute :'total.extras.setup', type: :integer
  # The total cost of bandwidth and requests used this month.
  attribute :'total.incurred_cost', type: :integer
  # How much over the plan minimum has been incurred.
  attribute :'total.overage', type: :integer
  # The short code the plan this invoice was generated under.
  attribute :'total.plan_code'
  # The minimum cost of this plan.
  attribute :'total.plan_minimum', type: :integer
  # The name of the plan this invoice was generated under.
  attribute :'total.plan_name'
  # The total number of requests used this month.
  attribute :'total.requests', type: :integer
  # The cost of the requests used this month.
  attribute :'total.requests_cost', type: :integer
  # Payment terms. Almost always Net15.
  attribute :'total.terms'
end
