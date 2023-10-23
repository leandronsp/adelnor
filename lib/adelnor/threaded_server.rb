# frozen_string_literal: true

require_relative './base_server'

module Adelnor
  class ThreadedServer < BaseServer
    def initialize(rack_app, port, options = {})
      super(rack_app, port, options)

      @thread_queue = Queue.new
      @pool_size = options[:thread_pool]
    end

    def run
      @pool_size.times do
        Thread.new do
          tid = Thread.current.object_id

          puts "[#{tid}] Thread started"
          loop do
            client = @thread_queue.pop

            handle(client)
            client.close
          end
        end
      end

      loop do
        client, = @socket.accept

        @thread_queue.push(client)
      end
    end
  end
end
