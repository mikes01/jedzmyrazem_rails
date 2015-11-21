FactoryGirl.define do
  factory :journey do
    factory :journey_with_path, class: Hash do
      spaces 6
      date '2015-05-14'
      path [{ 'point' => [51.1141377, 17.0534637],
              'time' => '12:50' },
            { 'point' => [51.114811, 17.066875],
              'time' => '13:01' },
            { 'point' => [51.116724, 17.051382],
              'time' => '14:51' }]

      initialize_with { attributes }
    end

    factory :journeys do
      date '2016-01-01'
      driver_id 1
      factory :journey_11_21_31_41_51_61_71_81 do
        spaces 4
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_11, time: '12:00', journey: journey)
          FactoryGirl.create(:waypoint_21, time: '12:15', journey: journey)
          FactoryGirl.create(:waypoint_31, time: '12:30', journey: journey)
          FactoryGirl.create(:waypoint_41, time: '12:45', journey: journey)
          FactoryGirl.create(:waypoint_51, time: '13:00', journey: journey)
          FactoryGirl.create(:waypoint_61, time: '13:15', journey: journey)
          FactoryGirl.create(:waypoint_71, time: '13:30', journey: journey)
          FactoryGirl.create(:waypoint_81, time: '13:45', journey: journey)
        end
      end

      factory :journey_82_72_62_52_42_32_22_12 do
        spaces 4
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_82, time: '12:00', journey: journey)
          FactoryGirl.create(:waypoint_72, time: '12:15', journey: journey)
          FactoryGirl.create(:waypoint_62, time: '12:30', journey: journey)
          FactoryGirl.create(:waypoint_52, time: '12:45', journey: journey)
          FactoryGirl.create(:waypoint_42, time: '13:00', journey: journey)
          FactoryGirl.create(:waypoint_32, time: '13:15', journey: journey)
          FactoryGirl.create(:waypoint_22, time: '13:30', journey: journey)
          FactoryGirl.create(:waypoint_12, time: '13:45', journey: journey)
        end
      end

      factory :journey_23_73_83 do
        spaces 2
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_23, time: '12:00', journey: journey)
          FactoryGirl.create(:waypoint_73, time: '12:20', journey: journey)
          FactoryGirl.create(:waypoint_83, time: '13:00', journey: journey)
        end
      end

      factory :journey_82_73_23 do
        spaces 2
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_82, time: '12:00', journey: journey)
          FactoryGirl.create(:waypoint_73, time: '12:20', journey: journey)
          FactoryGirl.create(:waypoint_23, time: '13:00', journey: journey)
        end
      end

      factory :journey_24_74_84_14 do
        spaces 3
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_24, time: '12:40', journey: journey)
          FactoryGirl.create(:waypoint_74, time: '13:40', journey: journey)
          FactoryGirl.create(:waypoint_84, time: '13:47', journey: journey)
          FactoryGirl.create(:waypoint_14, time: '13:57', journey: journey)
        end
      end

      factory :journey_15_64 do
        spaces 3
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_15, time: '14:05', journey: journey)
          FactoryGirl.create(:waypoint_64, time: '14:15', journey: journey)
        end
      end

      factory :journey_15_64_nospace do
        spaces 0
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_15, time: '14:06', journey: journey)
          FactoryGirl.create(:waypoint_64, time: '14:16', journey: journey)
        end
      end

      factory :journey_15_64_before do
        spaces 3
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_15, time: '13:05', journey: journey)
          FactoryGirl.create(:waypoint_64, time: '13:15', journey: journey)
        end
      end

      factory :journey_15_64_late do
        spaces 3
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_15, time: '14:25', journey: journey)
          FactoryGirl.create(:waypoint_64, time: '14:45', journey: journey)
        end
      end

      factory :journey_35_12_85 do
        spaces 7
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_35, time: '13:25', journey: journey)
          FactoryGirl.create(:waypoint_12, time: '13:45', journey: journey)
          FactoryGirl.create(:waypoint_85, time: '13:55', journey: journey)
        end
      end

      factory :journey_42_63_84_73 do
        spaces 7
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_42, time: '13:15', journey: journey)
          FactoryGirl.create(:waypoint_63, time: '13:25', journey: journey)
          FactoryGirl.create(:waypoint_84, time: '13:35', journey: journey)
          FactoryGirl.create(:waypoint_73, time: '13:55', journey: journey)
        end
      end

      factory :journey_85_12_35_day_before do
        spaces 7
        date '2015-12-31'
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_85, time: '13:25', journey: journey)
          FactoryGirl.create(:waypoint_12, time: '13:45', journey: journey)
          FactoryGirl.create(:waypoint_35, time: '13:55', journey: journey)
        end
      end

      factory :journey_85_12_35_day_after do
        date '2016-01-02'
        spaces 7
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_85, time: '13:25', journey: journey)
          FactoryGirl.create(:waypoint_12, time: '13:45', journey: journey)
          FactoryGirl.create(:waypoint_35, time: '13:55', journey: journey)
        end
      end

      factory :journey_35_22_73 do
        spaces 7
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_35, time: '13:25', journey: journey)
          FactoryGirl.create(:waypoint_22, time: '13:45', journey: journey)
          FactoryGirl.create(:waypoint_73, time: '13:55', journey: journey)
        end
      end
      factory :journey_65_32_44_53 do
        spaces 4
        after(:create) do |journey|
          FactoryGirl.create(:waypoint_65, time: '14:25', journey: journey)
          FactoryGirl.create(:waypoint_32, time: '14:45', journey: journey)
          FactoryGirl.create(:waypoint_44, time: '14:55', journey: journey)
          FactoryGirl.create(:waypoint_53, time: '15:15', journey: journey)
        end
      end
    end
  end
end
