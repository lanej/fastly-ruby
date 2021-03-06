# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Fastly do
  let(:version) { a_version(locked: false) }
  let(:service) { version.service }

  def create_attributes(overrides = {})
    {
      service_id: service.id,
      version_number: version.number,
      name: SecureRandom.hex(3),
      content_type: 'application/json',
      status: '404',
      response: 'ok',
      content: "{'error': ['not found']}",
    }.merge(overrides)
  end

  it 'creates a response_object' do
    name = SecureRandom.hex(3)

    response_object = client.response_objects.create(create_attributes(name: name))

    expect(response_object.name).to eq(name)
    expect(response_object.reload.name).to eq(name)
  end

  it 'creates a response_object with a cache condition' do
    condition = a_condition(version: version, type: 'CACHE')
    response_object = client.response_objects.create(create_attributes(cache_condition: condition.name))

    expect(response_object.cache_condition).to eq(condition)
    expect(response_object.reload.cache_condition).to eq(condition)
  end

  it 'creates a response_object with a request condition' do
    condition = a_condition(version: version, type: 'REQUEST')
    response_object = client.response_objects.create(create_attributes(request_condition: condition.name))

    expect(response_object.request_condition).to eq(condition)
    expect(response_object.reload.request_condition).to eq(condition)
  end

  it 'does not create response_object with a request condition with an invalid type' do
    condition = a_condition(version: version, type: 'RESPONSE')
    expect do
      client.response_objects.create(create_attributes(request_condition: condition.name))
    end.to raise_error(Fastly::Response::BadRequest, /Condition '#{condition.name}' is not a request condition/)
  end

  it 'does not create response_object with a cache condition with an invalid type' do
    condition = a_condition(version: version, type: 'RESPONSE')
    expect do
      client.response_objects.create(create_attributes(cache_condition: condition.name))
    end.to raise_error(Fastly::Response::BadRequest, /Condition '#{condition.name}' is not a request condition/)
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
