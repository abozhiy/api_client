# frozen_string_literal: true

module Api
  class ClientFactory
    def self.call(**attributes)
      klass.new(attributes)
    end

    private

    def klass
      return Api::FakeClient if fake_api?

      Api::Client
    end

    def fake_api?
      ENV['API_FAKE'].eql? 1
    end
  end
end
