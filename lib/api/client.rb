# frozen_string_literal: true

module Api
  class Client < BaseClient
    def get_auth_token
      get_auth_token_request
    end

    def create_customer(**params)
      response = create_customer_request(params: params)
      if response.code.eql? 401
        get_auth_token_request
        create_customer_request(params: params)
      else
        response
      end
    end

    private

    def get_auth_token_request
      Api::Requests::GetAuthTokenRequest.request(
        logger: @logger,
        tracker: @tracker
      )
    end

    def create_customer_request(params:)
      Api::Requests::CreateCustomerRequest.request(
        logger: @logger,
        tracker: @tracker,
        params: params
      )
    end
  end
end
