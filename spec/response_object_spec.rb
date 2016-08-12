# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  it 'creates a response_object' do
    name = SecureRandom.hex(3)

    response_object = client.response_objects.create(
      service_id: service.id,
      version_number: version.number,
      name: name,
      content_type: 'application/json',
      status: '404',
      response: 'ok',
      content: "{'error': ['not found']}",
    )

    expect(response_object.name).to eq(name)
    expect(response_object.reload.name).to eq(name)
  end

  describe 'with a response_object' do
    let!(:response_object) { a_response_object(version: version) }

    it 'updates a response_object' do
      new_content = SecureRandom.uuid

      copy = response_object.dup

      expect do
        response_object.update(content: new_content)
      end.to change(response_object, :content).from(response_object.content).to(new_content)
        .and change { copy.reload.content } .from(response_object.content).to(new_content)
    end

    it 'lists response_objects' do
      expect(version.response_objects.all).to include(response_object)
    end

    it 'destroys a response_object' do
      expect do
        response_object.destroy
      end.to change(response_object, :reload).to(nil)
    end
  end
end
