# frozen_string_literal: true

module Adelnor
  class Response
    def initialize(status, headers, body)
      @status  = status
      @headers = headers
      @body    = body.respond_to?(:first) ? body.first : body
    end

    def self.build(*args)
      new(*args).build
    end

    def build
      "HTTP/2.0 #{@status}\r\n#{headers_as_string}\r\n#{@body}"
    end

    private

    def headers_as_string = @headers.reduce('', &method(:header_as_string))

    def header_as_string(acc, (key, value)) = acc += "#{key}: #{value}\r\n"
  end
end
