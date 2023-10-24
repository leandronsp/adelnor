# frozen_string_literal: true

require_relative './base_server'
require 'async'
require 'async/scheduler'

module Adelnor
  class AsyncServer < BaseServer
    def run
      scheduler = Async::Scheduler.new
      Fiber.set_scheduler(scheduler)

      Async do |task|
        loop do
          client, = @socket.accept

          task.async do
            @handler.handle(client)
            client.close
          end
        end
      end
    end
  end
end
