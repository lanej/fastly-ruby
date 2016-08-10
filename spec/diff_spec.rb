# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let!(:service) { a_service }
  let!(:version_a) { a_version(service: service, locked: false) }
  let!(:version_b) { version_a.clone! }

  it 'diffs two versions' do
    diff = version_a.diff(version_b)

    expect(diff.from_version).to eq(version_a)
    expect(diff.to_version).to eq(version_b)
    expect(diff.diff).not_to be_empty
  end
end
