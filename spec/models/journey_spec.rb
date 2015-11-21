require 'rails_helper'

RSpec.describe Journey, type: :model do
  before(:each) do
    FactoryGirl.create(:user)
    FactoryGirl.create(:journey_11_21_31_41_51_61_71_81)
    FactoryGirl.create(:journey_82_72_62_52_42_32_22_12)
    FactoryGirl.create(:journey_13_73_83)
    FactoryGirl.create(:journey_24_74_84_14)
    FactoryGirl.create(:journey_15_64)
    FactoryGirl.create(:journey_15_64_nospace)
    FactoryGirl.create(:journey_15_64_before)
    FactoryGirl.create(:journey_15_64_late)
    FactoryGirl.create(:journey_35_12_85)
    FactoryGirl.create(:journey_85_12_35_day_before)
    FactoryGirl.create(:journey_85_12_35_day_after)
  end
  describe 'get_journeys_in_period' do
    let(:user) { FactoryGirl.create(:user) }
    it 'returns journey in 2 hours period' do
      journeys = Journey.get_journeys_in_period('11:50', '2016-01-01')
      expect(journeys.count).to eq(6)
    end
  end
  describe 'search_journeys' do
    context 'with directly journeys' do
      before(:each) do
        start_point = FactoryGirl.build(:waypoint_14)
        finish_point = FactoryGirl.build(:waypoint_84)

        @parameters = { date: '2016-01-01',
                        start_lat: start_point.point.x,
                        start_lng: start_point.point.y,
                        finish_lat: finish_point.point.x,
                        finish_lng: finish_point.point.y,
                        start_time: '11:50'
        }
      end
      it 'return journeys' do
        journeys = Journey.search_journeys(@parameters)
        expect(journeys.count).to eq(3)
      end
    end

    # context 'with journeys made up of two intermediate passes' do
    #   it 'return journeys' do
    #     journeys = Journey.search_journeys
    #     expect(journeys.count).to eq(2)
    #     pending "Not implemented yet"
    #   end
    # end

    # context 'with journeys made up of three or four intermediate passes' do
    #   it 'return journeys' do
    #     journeys = Journey.search_journeys
    #     expect(journeys.count).to eq(2)
    #   end
    # end
  end
end
