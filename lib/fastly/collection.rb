# frozen_string_literal: true
module Fastly::Collection
  def first(**query)
    query.empty? ? super() : all(query).first
  end

  def last(**query)
    query.empty? ? super() : all(query).last
  end

  def new(new_attributes = {})
    super(attributes.merge(new_attributes))
  end

  def get(*args)
    get!(*args)
  rescue Fastly::Response::NotFound
    nil
  end
end
