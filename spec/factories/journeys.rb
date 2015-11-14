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
  end
end
