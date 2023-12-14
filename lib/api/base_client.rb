# frozen_string_literal: true

class Api
  class BaseClient
    def initialize(logger:, tracker: nil)
      @logger = logger
      @tracker = tracker
    end

    def get_auth_token
      raise NotImplementedError
    end

    def create_customer(**params)
      raise NotImplementedError
    end
  end
end
