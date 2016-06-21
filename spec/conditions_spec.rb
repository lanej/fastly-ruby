# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Conditions' do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a condition' do
    name = SecureRandom.hex(3)

    condition = client.conditions.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
      type: 'CACHE',
      statement: 'req.url~+"index.html"',
      priority: 10,
    )

    expect(condition.name).to eq(name)
    expect(condition.reload.name).to eq(name)
  end
end
