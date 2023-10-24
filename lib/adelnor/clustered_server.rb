# frozen_string_literal: true

require_relative './base_server'

module Adelnor
  class ClusteredServer < BaseServer
    def initialize(rack_app, port, options = {})
      super(rack_app, port, options)

      @workers = options[:workers]
    end

    def run
      @workers.times do
        fork { handle_worker }
      end

      Process.waitall
    end

    def handle_worker
      pid = Process.pid
      puts "[#{pid}] Worker started"

      loop do
        client, = @socket.accept

        handle(client)
        client.close
      end
    end
  end
end
