# frozen_string_literal: true

require_relative './base_server'
require_relative './threaded_server'

module Adelnor
  class Server
    def initialize(rack_app, port, options = {})
      @rack_app = rack_app
      @port     = port
      @options  = options
    end

    def self.run(*args)
      new(*args).run
    end

    def run
      handler_klass = @options[:thread_pool] ? ThreadedServer : BaseServer
      handler_klass.run(@rack_app, @port, @options)
    end
  end
end
