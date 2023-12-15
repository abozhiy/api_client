# frozen_string_literal: true

module Api
  module Requests
    class CreateCustomerRequest < BaseRequest
      def request
        wrap_request do
          http.post(url, @params.to_json, headers)
        end
      end

      private

      def path
        'create-customer'
      end
    end
  end
end
