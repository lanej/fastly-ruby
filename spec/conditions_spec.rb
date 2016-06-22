# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
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

  describe 'with a condition' do
    let(:condition) { a_condition(version: version) }

    it 'updates a condition' do
      new_statement = 'vcl'

      copy = condition.dup

      expect do
        condition.update(statement: new_statement)
      end.to change(condition, :statement).from(condition.statement).to(new_statement)
        .and change { copy.reload.statement } .from(condition.statement).to(new_statement)
    end

    it 'lists conditions' do
      expect(version.conditions).to include(condition)
    end

    it 'destroys a condition' do
      expect do
        condition.destroy
      end.to change(condition, :reload).to(nil)
    end
  end
end
