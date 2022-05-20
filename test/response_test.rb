# frozen_string_literal: true

require 'test/unit'
require 'json'

require './lib/adelnor/response'

module Adelnor
  class ResponseTest < Test::Unit::TestCase
    def test_simple_response
      status   = 200
      headers  = {}
      body     = ''
      response = Adelnor::Response.build(status, headers, body)

      assert_equal "HTTP/2.0 200\r\n\r\n", response
    end

    def test_with_headers_response
      status   = 200
      headers  = { 'Content-Type' => 'text/html' }
      body     = ''
      response = Adelnor::Response.build(status, headers, body)

      assert_equal "HTTP/2.0 200\r\nContent-Type: text/html\r\n\r\n", response
    end

    def test_full_response
      status   = 201
      headers  = { 'Content-Type' => 'application/json' }
      body     = { success: true }.to_json
      response = Response.build(status, headers, body)

      assert_equal "HTTP/2.0 201\r\nContent-Type: application/json\r\n\r\n{\"success\":true}", response
    end
  end
end
