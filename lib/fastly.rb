# frozen_string_literal: true
require 'fastly/version'

require 'logger'
require 'securerandom'

require 'cistern'
require 'faraday'
require 'faraday_middleware'
require 'faraday/detailed_logger'

module Fastly
  include Cistern::Client.with(interface: :module)

  USER_AGENT = "Fastly/#{Fastly::VERSION} Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}"

  recognizes :username, :password, :token, :url, :adapter, :logger
end

require 'fastly/token_middleware'
require 'fastly/response'
require 'fastly/request'
require 'fastly/collection'
require 'fastly/service_version_model'
require 'fastly/model'

require 'fastly/customer'
require 'fastly/customers'
require 'fastly/get_customer'
require 'fastly/get_current_customer'

require 'fastly/get_service'
require 'fastly/get_services'
require 'fastly/create_service'
require 'fastly/destroy_service'
require 'fastly/update_service'
require 'fastly/search_services'
require 'fastly/service'
require 'fastly/services'

require 'fastly/create_version'
require 'fastly/get_versions'
require 'fastly/get_version'
require 'fastly/update_version'
require 'fastly/activate_version'
require 'fastly/deactivate_version'
require 'fastly/clone_version'
require 'fastly/validate_version'
require 'fastly/lock_version'
require 'fastly/version_model'
require 'fastly/versions'

require 'fastly/backend'
require 'fastly/backends'
require 'fastly/create_backend'
require 'fastly/get_backends'
require 'fastly/get_backend'
require 'fastly/update_backend'
require 'fastly/destroy_backend'

require 'fastly/domain'
require 'fastly/domains'
require 'fastly/create_domain'
require 'fastly/get_domains'
require 'fastly/get_domain'
require 'fastly/update_domain'
require 'fastly/destroy_domain'

require 'fastly/dictionary'
require 'fastly/dictionaries'
require 'fastly/create_dictionary'
require 'fastly/get_dictionaries'
require 'fastly/get_dictionary'
require 'fastly/update_dictionary'
require 'fastly/destroy_dictionary'

require 'fastly/dictionary_item'
require 'fastly/dictionary_items'
require 'fastly/create_dictionary_item'
require 'fastly/get_dictionary_items'
require 'fastly/get_dictionary_item'
require 'fastly/upsert_dictionary_item'
require 'fastly/destroy_dictionary_item'

require 'fastly/condition'
require 'fastly/conditions'
require 'fastly/create_condition'
require 'fastly/get_condition'
require 'fastly/get_conditions'
require 'fastly/update_condition'

require 'fastly/real'
require 'fastly/mock'
