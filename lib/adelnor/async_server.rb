# frozen_string_literal: true

require_relative './base_server'
require 'async'
require 'async/scheduler'

module Adelnor
  class AsyncServer < BaseServer
    def initialize(rack_app, port, options = {})
      super(rack_app, port, options)

      scheduler = Async::Scheduler.new
      Fiber.set_scheduler(scheduler)
    end

    def run
      Async do |task|
        loop do
          client, = @socket.accept

          task.async do
            handle(client)
            client.close
          end
        end
      end
    end
  end
end
