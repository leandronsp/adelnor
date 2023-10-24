# frozen_string_literal: true
# rubocop:disable all

require_relative './base_server'

module Adelnor
  class RactorServer < BaseServer
    def run
      ractors = @options[:ractors].times.map do
        Ractor.new(queue, @handler) do |queue, handler|
          rid = Ractor.current.object_id
          puts "[#{rid}] Ractor started"

          loop do
            client = queue.take

            handler.handle(client)
            client.close
          end
        end
      end

      loop do
        Ractor.select(listener, *ractors)
      end
    end

    private

    def listener
      @listener ||= Ractor.new(@socket, queue) do |socket, queue|
        loop do
          client, = socket.accept

          queue.send(client, move: true)
        end
      end
    end

    def queue
      @queue ||= Ractor.new do
        loop do
          Ractor.yield(Ractor.receive, move: true)
        end
      end
    end
  end
end
# rubocop:enable all
