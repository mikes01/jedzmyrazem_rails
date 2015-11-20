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

  def format
    result = as_json
    result['waypoints'] = []
    waypoints.each do |waypoint|
      result['waypoints'].push("point":
        { "lat": waypoint.point.x, "lng": waypoint.point.y },
                               "time": waypoint.time)
    end
    result['user'] = driver.username
    result
  end

  def self.get_formated_journays(parameters)
    result = []
    Journey.includes(:waypoints).where(date: parameters[:date])
      .where('ST_Distance(waypoints.point, '\
        "'POINT(#{parameters[:start_lat]} "\
          "#{parameters[:start_lng]})') < 5000")
      .where('waypoints.time > ?', parameters[:start_time])
      .references(:waypoints).each do |j|
        result.push j.format
      end
    result
  end
end
