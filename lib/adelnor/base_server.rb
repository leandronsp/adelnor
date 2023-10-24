# frozen_string_literal: true

require 'socket'
require 'rack'
require 'stringio'

require_relative './request'
require_relative './response'
require_relative './handler'

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

      @handler = Handler.new(@rack_app, @port)

      puts welcome_message
    end

    def self.run(*args)
      new(*args).run
    end

    def run
      loop do
        client, = @socket.accept

        @handler.handle(client)
        client.close
      end
    end

    def welcome_message
      if @options[:thread_pool]
        message = "Running with thread pool of #{@options[:thread_pool]} threads"
      elsif @options[:workers]
        message = "Running with #{@options[:workers]} workers"
      elsif @options[:ractors]
        message = "Running with #{@options[:ractors]} ractors"
      elsif @options[:async]
        message = "Running in async mode"
      else 
      end


      <<~WELCOME
        |\---/|
        | o_o |
         \_^_/

        adelnor HTTP server

        ------------------------------------------------

        Adelnor is running at http://0.0.0.0:#{@port}
        Listening to HTTP connections

        #{message}
      WELCOME
    end
  end
end
