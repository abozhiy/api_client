# frozen_string_literal: true

module Api
  module Requests
    class BaseRequest
      GET_TOKEN = 'getToken'
      AUTH_CACHE_KEY = 'api/auth_token'
      API_URL = ENV['API_URL']

      def initialize(logger:, tracker:, params: {})
        @logger = logger
        @tracker = tracker
        @params = params
      end

      def self.request(logger:, tracker:, params: {})
        new(logger: logger, tracker: tracker, params: params).request
      end

      def request
        raise NotImplementedError
      end

      def wrap_request
        logger_start
        track_request(response: response = yield)
        logger_end
        response
      rescue Net::HTTP::Error, StandardError => e
        logger_error(e)
        raise e.message
      end

      private

      def path
        raise NotImplementedError
      end

      def request_id
        @request_id ||= "#{Rails.env}-#{SecureRandom.uuid}"
      end

      def track_request(response:)
        return if @tracker.nil?

        @tracker.track_request(
          request_id: request_id,
          action: path,
          request: @params,
          response: @response.to_h.pretty_inspect
        )
      end

      def http
        Net::HTTP.
          new(url.host, url.port).
          timeout(connect: 10, write: 30, read: 60)
      end

      def headers
        {
          'Accept' => 'application/json',
          'Authorization' => auth_token,
          'request_id' => request_id
        }
      end

      def url
        URI.parse("#{API_URL}/#{path}")
      end

      def auth_token
        return if path.eql? GET_TOKEN

        Rails.cache.read(AUTH_CACHE_KEY)
      end

      def logger_start
        @logger.info "Start #{path} call"
      end

      def logger_end
        @logger.info "End #{path} call. Received response: #{response.inspect}"
      end

      def logger_error(e)
        @logger.error "::Api::Client: #{e.class}: #{e}"
      end
    end
  end
end
