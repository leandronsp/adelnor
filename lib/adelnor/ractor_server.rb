# frozen_string_literal: true

require_relative './base_server'

module Adelnor
  class RactorServer < BaseServer
    def initialize(rack_app, port, options = {})
      @ractors = options[:ractors]

      @rack_app = rack_app
      @port     = port
      @options  = options

      @queue = Ractor.new do
        loop do
          Ractor.yield(Ractor.receive, move: true)
        end
      end

      @listener = Ractor.new(@queue, @port) do |queue, port|
        socket   = Socket.new(:INET, :STREAM)
        addr      = Socket.sockaddr_in(port, '0.0.0.0')

        socket.bind(addr)
        socket.listen(2)

        loop do
          client, = socket.accept

          queue.send(client, move: true)
        end
      end

      puts welcome_message
    end

    def run
      ractors = @ractors.times.map do 
        Ractor.new(@queue, @rack_app, @port) do |queue, rack_app, port|
          rid = Ractor.current.object_id
          puts "[#{rid}] Ractor started"

          loop do
            client = queue.take
            message = ''

            if (line = client.gets)
              message += line
            end

            puts "\n[#{Time.now}] #{message}"

            while (line = client.gets)
              break if line == "\r\n"

              message += line
            end

            rack_data = -> (request) do
              { 
                'REQUEST_METHOD' => request.request_method,
                'PATH_INFO' => request.path_info,
                'QUERY_STRING' => request.query_string,
                'SERVER_PORT' => port,
                'SERVER_NAME' => request.headers['Host'],
                'CONTENT_LENGTH' => request.content_length,
                'HTTP_COOKIE' => request.headers['Cookie'],
                'rack.input' => StringIO.new(request.body)
              }
            end

            Request.build(message)
              .tap  { |request|  request.parse_body!(client) }
              .then { |request|  rack_data.call(request).merge(request.headers) }
              .then { |data|     rack_app.call(data) }
              .then { |result|   Response.build(*result) }
              .then { |response| client.puts(response) }

            client.close
          end
        end
      end

      loop do
        Ractor.select(@listener, *ractors)
      end
    end
  end
end
