# Model for manage waypoints of journey
class Waypoint < ActiveRecord::Base
  belongs_to :journey

  def self.create_from_array(path, journey)
    path.each do |point|
      point[:journey] = journey
      Waypoint.create!(point)
    end
  end
end
