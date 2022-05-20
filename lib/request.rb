module Adelnor
  class Request
    attr_reader :request_method, :request_path, :headers, :body,
      :content_length, :path_info, :query_string

    def initialize(message)
      @message = message
      @request_method = @request_path = nil

      @headers = {}
      @body    = ''
    end

    def self.build(*args)
      new(*args).build
    end

    def build
      lines    = @message.split(/\r\n/)
      headline = lines.shift

      parse_headline!(headline)
      parse_headers!(lines)

      self
    end

    def parse_body!(client)
      @content_length = @headers['Content-Length']
      return unless @content_length

      @body = client.read(@content_length.to_i)
    end

    private

    def parse_headline!(line)
      return unless line.match(/HTTP\/.*?/)

      @request_method, @request_path, _ = line.split
      @path_info, @query_string         = @request_path.split('?')
    end

    def parse_headers!(lines)
      lines.each(&method(:parse_header!))
    end

    def parse_header!(line)
      header_key, header_value = line.split(': ')
      @headers[header_key] = header_value
    end
  end
end
