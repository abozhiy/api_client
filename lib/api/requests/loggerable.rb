# frozen_string_literal: true

module Api
  module Requests
    module Loggerable
      def logger_start
        @logger.info "Start #{path} call"
      end

      def logger_end(response:)
        @logger.info "End #{path} call. Received response: #{response.inspect}"
      end

      def logger_error(e)
        @logger.error "::Api::Client: #{e.class}: #{e}"
      end
    end
  end
end
