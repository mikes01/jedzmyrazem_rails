require 'rails_helper'

RSpec.describe Journey, type: :model do
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
  end
  describe 'get_journeys_in_period' do
    let(:user) { FactoryGirl.create(:user) }
    it 'returns journey in 2 hours period' do
      journeys = Journey.get_journeys_in_period('11:50', '2016-01-01')
      expect(journeys.count).to eq(8)
    end
  end
  describe 'search_journeys' do
    context 'with directly journeys' do
      before(:each) do
        start_point = FactoryGirl.build(:waypoint_14)
        finish_point = FactoryGirl.build(:waypoint_83)

        @parameters = { date: '2016-01-01',
                        start_lat: start_point.point.x,
                        start_lng: start_point.point.y,
                        finish_lat: finish_point.point.x,
                        finish_lng: finish_point.point.y,
                        start_time: '12:00'
        }
      end
      it 'return journeys' do
        journeys = Journey.search_journeys(@parameters)
        expect(journeys.count).to eq(2)
      end
      it 'return journeys made with one pass' do
        journeys = Journey.search_journeys @parameters
        journeys.each do |j|
          expect(j.count). to eq(1)
        end
      end
    end

    context 'with journeys made up of two intermediate passes' do
      before(:each) do
        start_point = FactoryGirl.build(:waypoint_35)
        finish_point = FactoryGirl.build(:waypoint_64)

        @parameters = { date: '2016-01-01',
                        start_lat: start_point.point.x,
                        start_lng: start_point.point.y,
                        finish_lat: finish_point.point.x,
                        finish_lng: finish_point.point.y,
                        start_time: '13:00'
        }
      end
      it 'return journeys' do
        journeys = Journey.search_journeys @parameters
        expect(journeys.count).to eq(1)
      end
      it 'return journeys made with two passes' do
        journeys = Journey.search_journeys @parameters
        journeys.each do |j|
          expect(j.count).to eq(2)
        end
      end
    end

    context 'with journeys made up of three or more intermediate passes' do
      before(:each) do
        start_point = FactoryGirl.build(:waypoint_35)
        finish_point = FactoryGirl.build(:waypoint_54)

        @parameters = { date: '2016-01-01',
                        start_lat: start_point.point.x,
                        start_lng: start_point.point.y,
                        finish_lat: finish_point.point.x,
                        finish_lng: finish_point.point.y,
                        start_time: '13:30'
        }
      end
      it 'return journeys' do
        journeys = Journey.search_journeys(@parameters)
        expect(journeys.count).to eq(1)
      end
      it 'return journeys made with more than two passes' do
        journeys = Journey.search_journeys @parameters
        expect(journeys.first.count).to be > 2
      end
    end
  end

  describe 'sort_journeys' do
    before(:each) do
      @journeys = Journey.all.includes(:waypoints)
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

    it('find all direct journeys') do
      sorted_journeys = Journey.sort_journeys(@journeys, @parameters)
      expect(sorted_journeys[:direct].count).to eq(2)
    end
    it('find all journeys with start_point') do
      sorted_journeys = Journey.sort_journeys(@journeys, @parameters)
      expect(sorted_journeys[:with_start].count).to eq(6)
    end
    it('find all journeys with finish_point') do
      sorted_journeys = Journey.sort_journeys(@journeys, @parameters)
      expect(sorted_journeys[:with_finish].count).to eq(3)
    end
    it('find all journeys without finish_point and start_point') do
      sorted_journeys = Journey.sort_journeys(@journeys, @parameters)
      expect(sorted_journeys[:middle].count).to eq(3)
    end
  end

  describe 'find_intersection_point' do
    context 'if intersection point exists' do
      it('returns two not nil') do
        first = FactoryGirl.create(:journey_35_12_85)
        second = FactoryGirl.create(:journey_15_64)
        p1, p2 = first.find_intersection_point(second)
        expect(p1).to_not be_nil
        expect(p2).to_not be_nil
      end
      it('returns intersections indexes') do
        first = FactoryGirl.create(:journey_35_12_85)
        second = FactoryGirl.create(:journey_15_64)
        p1, p2 = first.find_intersection_point(second)
        expect(p1).to eq(1)
        expect(p2).to eq(0)
      end
    end
    context 'if second time is before first' do
      it('returns two nil') do
        first = FactoryGirl.create(:journey_15_64)
        second = FactoryGirl.create(:journey_35_12_85)
        p1, p2 = first.find_intersection_point(second)
        expect(p1).to be_nil
        expect(p2).to be_nil
      end
    end
    context 'if intersection point is last of second journey' do
      it('returns two nil') do
        first = FactoryGirl.create(:journey_42_63_84_73)
        second = FactoryGirl.create(:journey_35_12_85)
        p1, p2 = first.find_intersection_point(second)
        expect(p1).to be_nil
        expect(p2).to be_nil
      end
    end
  end

  describe 'find_complex_journeys' do
    before(:each) do
    end
    it 'returns complex journeys made with 3 passes' do
      @journeys = Journey.all.includes(:waypoints)
      start_point = FactoryGirl.build(:waypoint_35)
      finish_point = FactoryGirl.build(:waypoint_54)

      @parameters = { date: '2016-01-01',
                      start_lat: start_point.point.x,
                      start_lng: start_point.point.y,
                      finish_lat: finish_point.point.x,
                      finish_lng: finish_point.point.y,
                      start_time: '12:30'
      }
      @journeys = Journey.sort_journeys(@journeys, @parameters)
      journeys = Journey.find_complex_journeys(@journeys, 3)
      expect(journeys.first[:passes].count).to eq(3)
      expect(journeys.count).to eq(1)
    end
    it 'returns complex journeys made with 4 passes' do
      @journeys = Journey.all.includes(:waypoints)
      start_point = FactoryGirl.build(:waypoint_35)
      finish_point = FactoryGirl.build(:waypoint_73)

      @parameters = { date: '2016-01-01',
                      start_lat: start_point.point.x,
                      start_lng: start_point.point.y,
                      finish_lat: finish_point.point.x,
                      finish_lng: finish_point.point.y,
                      start_time: '13:30'
      }
      @journeys = Journey.sort_journeys(@journeys, @parameters)
      journeys = Journey.find_complex_journeys(@journeys, 4)
      expect(journeys.first[:passes].count).to eq(4)
      expect(journeys.count).to eq(1)
    end
  end
end
