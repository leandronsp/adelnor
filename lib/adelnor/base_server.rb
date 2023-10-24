# frozen_string_literal: true

require 'socket'
require 'rack'
require 'stringio'

require_relative './request'
require_relative './response'

module Adelnor
  class BaseServer
    def initialize(rack_app, port, options = {})
      @rack_app = rack_app
      @port     = port
      @options  = options
      @socket   = Socket.new(:INET, :STREAM)
      addr      = Socket.sockaddr_in(@port, '0.0.0.0')

      @socket.bind(addr)
      @socket.listen(2)

      puts welcome_message
    end

    def self.run(*args)
      new(*args).run
    end

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

    def run
      loop do
        client, = @socket.accept

        handle(client)
        client.close
      end
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

    def welcome_message
      thread_pool_message = "Running with thread pool of #{@options[:thread_pool]} threads" if @options[:thread_pool]

      <<~WELCOME
        |\---/|
        | o_o |
         \_^_/

        adelnor HTTP server

        ------------------------------------------------

        Adelnor is running at http://0.0.0.0:#{@port}
        Listening to HTTP connections

        #{thread_pool_message}
      WELCOME
    end
  end
end
