require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  before(:each) do
    user = FactoryGirl.build(:user)
    allow_any_instance_of(JourneysController).to receive(:current_user)
      .and_return(user)
  end
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates the journey' do
        post :create, journey: FactoryGirl.attributes_for(:journey_with_path),
                      format: :json
        expect(Journey.count).to eq(1)
      end
    end
    context 'with failed waypoints saving' do
      it 'won\'t save trip' do
        allow(Waypoint).to receive(:create_from_array).and_raise('Error')
        post :create, journey: FactoryGirl.attributes_for(:journey_with_path),
                      format: :json
        expect(Journey.count).to eq(0)
      end
    end
  end
  describe 'GET #search' do
    before(:each) do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:journey_11_21_41_51_61_71_81, driver: user)
      FactoryGirl.create(:journey_82_72_62_52_42_32_22_12, driver: user)
      FactoryGirl.create(:journey_23_73_83, driver: user)
      FactoryGirl.create(:journey_82_73_23, driver: user)
      FactoryGirl.create(:journey_24_74_84_14, driver: user)
      FactoryGirl.create(:journey_15_64, driver: user)
      FactoryGirl.create(:journey_15_64_before, driver: user)
      FactoryGirl.create(:journey_15_64_late, driver: user)
      FactoryGirl.create(:journey_35_12_85, driver: user)
      FactoryGirl.create(:journey_85_12_35_day_before, driver: user)
      FactoryGirl.create(:journey_85_12_35_day_after, driver: user)
      FactoryGirl.create(:journey_35_22_73, driver: user)
      FactoryGirl.create(:journey_65_44_53, driver: user)
      FactoryGirl.create(:journey_55_73, driver: user)
      FactoryGirl.create(:journey_84_71, driver: user)
      FactoryGirl.create(:journey_72_51, driver: user)
      FactoryGirl.create(:journey_55_62, driver: user)
    end

    context 'with valid parameters' do
      it 'returns journeys' do
        get :search, FactoryGirl.attributes_for(:search_params),
            format: :json
        expect(JSON.parse(response.body)['journey'].count).to eq(3)
      end
      it 'returns journeys with diffrent complex' do
        get :search, FactoryGirl.attributes_for(:search_params),
            format: :json
        expect(JSON.parse(response.body)['journey'][0].count).to eq(1)
        expect(JSON.parse(response.body)['journey'][1].count).to eq(3)
        expect(JSON.parse(response.body)['journey'][2].count).to eq(2)
      end
    end
  end
end
