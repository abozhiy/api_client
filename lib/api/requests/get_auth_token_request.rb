# frozen_string_literal: true

module Api
  module Requests
    class GetAuthTokenRequest < BaseRequest
      API_USERNAME = Rails.application.secrets.dig(:api_user_name)
      API_PASSWORD = Rails.application.secrets.dig(:api_password)
      private_constant :API_USERNAME
      private_constant :API_PASSWORD
      EXPECTED_LENGTH = 16

      WrongAuthTokenLength = Class.new StandardError

      def request
        wrap_request do
          params = @params.merge(username: API_USERNAME, password: API_PASSWORD)
          response = http.post(url, params.to_json, headers)
          if response.kind_of? Net::HTTPSuccess
            token = response.dig('token')
            raise Api::Requests::GetAuthTokenRequest::WrongAuthTokenLength if token && token.length != EXPECTED_LENGTH

            Rails.cache.write(AUTH_CACHE_KEY, token, expires_in: 24.hours)
          end
          response
        end
      end

      private

      def path
        'getToken'
      end
    end
  end
end
