# Model for manage journeys
class Journey < ActiveRecord::Base
  belongs_to :driver, class_name: 'User', foreign_key: :driver_id
  has_many :waypoints

  def self.create_with_path(journey_with_path, user)
    Journey.transaction do
      journey = Journey.create!(date: journey_with_path[:date],
                                spaces: journey_with_path[:spaces],
                                driver: user)
      Waypoint.create_from_array(journey_with_path[:path], journey)
      journey
    end
  end
end
