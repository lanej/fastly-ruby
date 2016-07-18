# frozen_string_literal: true
class Fastly::Login
  include Fastly::Request

  request_method :post
  request_path { '/login' }
  request_params { |r| { 'user' => r.username, 'password' => r.password } }

  parameter :username, :password
end
