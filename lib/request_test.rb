require 'test/unit'
require 'stringio'

require './lib/request'

module Adelnor
  class RequestTest < Test::Unit::TestCase
    def test_parse_headline_and_headers
      message = <<-REQUEST
GET /?test=true HTTP/1.1\r\n\
Host: localhost:3000\r\n\
Cookie: counter=14; email=user@example.com\r\n
      REQUEST

      request = Adelnor::Request.build(message)

      assert_equal 'GET', request.request_method
      assert_equal '/?test=true', request.request_path
      assert_equal '/', request.path_info
      assert_equal 'test=true', request.query_string
      assert_equal 'localhost:3000', request.headers['Host']
      assert_equal 'counter=14; email=user@example.com', request.headers['Cookie']
      assert_equal "", request.body
    end

    def test_parse_body
      message = <<-REQUEST
POST / HTTP/1.1\r\n\
Host: localhost:3000\r\n\
Content-Length: 25\r\n\
\r\n\
email=user@example.com
      REQUEST

      request = Adelnor::Request.build(message)

      client = StringIO.new(message)
      until client.gets == "\r\n"; 1; end

      request.parse_body!(client)

      assert_equal 'POST', request.request_method
      assert_equal '/', request.request_path
      assert_equal 'localhost:3000', request.headers['Host']
      assert_equal '25', request.headers['Content-Length']
      assert_equal "email=user@example.com\n", request.body
    end
  end
end
