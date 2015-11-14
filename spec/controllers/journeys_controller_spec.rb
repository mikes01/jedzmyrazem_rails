require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates the journey' do
        post :create, journey: attributes_for(:journey_with_path), format: :json
        expect(Journey.count).to eq(1)
      end
    end
  end
end
