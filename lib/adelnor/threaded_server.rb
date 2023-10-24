# frozen_string_literal: true

require_relative './base_server'

module Adelnor
  class ThreadedServer < BaseServer
    def run
      @options[:thread_pool].times do
        Thread.new { handle_thread }
      end

      loop do
        client, = @socket.accept

        queue.push(client)
      end
    end

    private

    def queue
      @queue ||= Queue.new
    end

    def handle_thread
      tid = Thread.current.object_id
      puts "[#{tid}] Thread started"

      loop do
        client = queue.pop

        @handler.handle(client)
        client.close
      end
    end
  end
end
