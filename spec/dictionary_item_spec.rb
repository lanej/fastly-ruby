# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'DictionaryItem' do
  let!(:dictionary) { a_dictionary }
  let!(:service)    { dictionary.service }

  it 'creates a dictionary item' do
    key = SecureRandom.hex(3)
    value = SecureRandom.hex(3)

    item = client.dictionary_items(service_id: service.id, dictionary_id: dictionary.id).create(key: key, value: value)

    expect(item.key).to eq(key)
    expect(item.value).to eq(value)
    expect(item.service_id).to eq(service.id)
    expect(item.service).to eq(service)
    expect(item.dictionary_id).to eq(dictionary.id)
  end
end
