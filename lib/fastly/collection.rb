# frozen_string_literal: true
module Fastly::Collection
  def first(**query)
    query.empty? ? super() : all(query).first
  end

  def last(**query)
    query.empty? ? super() : all(query).last
  end
end
