# frozen_string_literal: true

require_relative './base_server'

module Adelnor
  class ClusteredServer < BaseServer
    def initialize(rack_app, port, options = {})
      super(rack_app, port, options)

      @cluster_size = options[:cluster]
    end

    def run
      @cluster_size.times do 
        fork do
          pid = Process.pid
          puts "[#{pid}] Worker started"

          loop do
            client, = @socket.accept

            handle(client)
            client.close
          end
        end
      end

      Process.waitall
    end
  end
end
