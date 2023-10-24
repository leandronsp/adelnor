# frozen_string_literal: true

require 'stringio'

require_relative './request'
require_relative './response'

module Adelnor
  class Handler
    def initialize(rack_app, port)
      @rack_app = rack_app
      @port     = port
    end

    def handle(client)
      read_request_message(client)
        .then { |message|  Request.build(message) }
        .tap  { |request|  request.parse_body!(client) }
        .then { |request|  rack_data(request) }
        .then { |data|     @rack_app.call(data) }
        .then { |result|   Response.build(*result) }
        .then { |response| client.puts(response) }
    end

    private

    def rack_data(request)
      {
        'REQUEST_METHOD' => request.request_method,
        'PATH_INFO' => request.path_info,
        'QUERY_STRING' => request.query_string,
        'SERVER_PORT' => @port,
        'SERVER_NAME' => request.headers['Host'],
        'CONTENT_LENGTH' => request.content_length,
        'HTTP_COOKIE' => request.headers['Cookie'],
        'rack.input' => StringIO.new(request.body)
      }.merge(request.headers)
    end

    def read_request_message(client)
      message = ''

      if (line = client.gets)
        message += line
      end

      puts "\n[#{Time.now}] #{message}"

      while (line = client.gets)
        break if line == "\r\n"

        message += line
      end

      message
    end
  end
end
