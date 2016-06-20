# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'DictionaryItem' do
  let!(:dictionary) { a_dictionary }
  let!(:service)    { dictionary.service }

  it 'creates a dictionary item' do
    key = SecureRandom.hex(3)
    value = SecureRandom.hex(3)

    item = dictionary.items.create(key: key, value: value)

    expect(item.key).to eq(key)
    expect(item.value).to eq(value)
    expect(item.service_id).to eq(service.id)
    expect(item.service).to eq(service)
    expect(item.dictionary_id).to eq(dictionary.id)
  end

  it 'conflicts when creating duplicate items' do
    key = SecureRandom.hex(3)
    value = SecureRandom.hex(3)

    dictionary.items.create(key: key, value: value)

    expect {
      dictionary.items.create(key: key, value: value)
    }.to raise_exception(Fastly::Response::Conflict, /Duplicate record/)
  end

  describe 'with a dictionary item' do
    let!(:dictionary_item) do
      dictionary.items.first ||
        dictionary.items.create(key: SecureRandom.hex(3), value: SecureRandom.hex(3))
    end

    it 'updates the value' do
      old_value = dictionary_item.value
      new_value = SecureRandom.hex(3)

      expect do
        dictionary_item.update(value: new_value)
      end.to change(dictionary_item, :value).from(old_value).to(new_value)
        .and change { dictionary.items.get(dictionary_item.key).value }.from(old_value).to(new_value)
    end
  end
end
