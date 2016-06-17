# frozen_string_literal: true
module Fastly::Model
  class << self
    alias cistern_included included
  end

  def self.included(receiver)
    cistern_included(receiver)
    receiver.extend(ClassMethods)
    super
  end

  module ClassMethods
    def associations
      @associations ||= []
    end

    def has_many(name, scope)
      reader_method = name
      writer_method = "#{name}="

      attribute name, type: :array

      define_method reader_method do
        attributes[name] || instance_exec(&scope)
      end

      define_method writer_method do |models|
        attributes[name] = instance_exec(&scope).load(
          Array(models).map { |model| model.respond_to?(:attributes) ? model.attributes : model }
        )
      end

      associations << name
    end
  end
end
