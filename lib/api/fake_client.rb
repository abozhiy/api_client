# frozen_string_literal: true

module Api
  class FakeClient < BaseClient
    def get_auth_token
      FakeResponse::TOKEN_RESPONSE
    end

    def create_customer(**params)
      FakeResponse::CREATE_CUSTOMER_RESPONSE
    end
  end
end
