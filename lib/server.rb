require 'socket'
require 'rack'
require 'stringio'

require './lib/request'
require './lib/response'

module Adelnor
  class Server
    def initialize(rack_app, port)
      @rack_app = rack_app
      @port     = port
      @socket   = Socket.new(:INET, :STREAM)
      addr      = Socket.sockaddr_in(@port, '0.0.0.0')

      @socket.bind(addr)
      @socket.listen(2)

      puts "Listening to the port #{@port}..."
    end

    def self.run(*args)
      new(*args).run
    end

    def rack_data(request)
      {
        'REQUEST_METHOD' => request.request_method,
        'PATH_INFO'      => request.path_info,
        'QUERY_STRING'   => request.query_string,
        'SERVER_PORT'    => @port,
        'SERVER_NAME'    => request.headers['Host'],
        'CONTENT_LENGTH' => request.content_length,
        'HTTP_COOKIE'    => request.headers['Cookie'],
        'rack.input'     => StringIO.new(request.body)
      }.merge(request.headers)
    end

    def run
      loop do
        client, _ = @socket.accept

        read_request_message(client)
          .then { |message|  Request.build(message) }
          .tap  { |request|  request.parse_body!(client) }
          .then { |request|  rack_data(request) }
          .then { |data|     @rack_app.call(data) }
          .then { |result|   Response.build(*result) }
          .then { |response| client.puts(response) }

        client.close
      end
    end

    def read_request_message(client)
      message = ''

      while line = client.gets
        break if line == "\r\n"

        message += line
      end

      message
    end
  end
end
