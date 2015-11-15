require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }
    context 'with valid attributes' do
      it 'creates the journey' do
        allow_any_instance_of(JourneysController).to receive(:current_user)
          .and_return(user)
        post :create, journey: FactoryGirl.attributes_for(:journey_with_path),
                      format: :json
        expect(Journey.count).to eq(1)
      end
    end
    context 'with failed waypoints saving' do
      it 'won\'t save trip' do
        allow_any_instance_of(JourneysController).to receive(:current_user)
          .and_return(user)
        allow(Waypoint).to receive(:create_from_array).and_raise('Error')
        post :create, journey: FactoryGirl.attributes_for(:journey_with_path),
                      format: :json
        expect(Journey.count).to eq(0)
      end
    end
  end
end
