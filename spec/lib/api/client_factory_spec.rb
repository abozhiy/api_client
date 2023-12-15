# frozen_string_literal: true

require 'rails_helper'

describe Api::ClientFactory do
  describe '.call' do
    subject(:call) { described_class.call(logger: OpenStruct.new, tracker: OpenStruct.new) }

    before do
      allow(Api::Client).to receive(:new)
      allow(Api::FakeClient).to receive(:new)

      allow(ENV).to receive(:[]).with('API_FAKE').and_return fake_result
    end

    context 'when fake_client' do
      let(:fake_result) { 1 }

      it 'calls fake client' do
        call
        expect(Api::FakeClient).to have_received(:new)
      end

      it 'doesnt call client' do
        call
        expect(Api::Client).not_to have_received(:new)
      end
    end

    context 'when client' do
      let(:fake_result) { 0 }

      it 'doesnt call fake client' do
        call
        expect(Api::FakeClient).not_to have_received(:new)
      end

      it 'calls client' do
        call
        expect(Api::Client).to have_received(:new)
      end
    end
  end
end
