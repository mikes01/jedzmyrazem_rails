# Model for manage waypoints of journey
class Waypoint < ActiveRecord::Base
  belongs_to :journey

  def self.create_from_array(path, journey)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    path.each do |point|
      point[:journey] = journey
      point[:point] = factory.point(point[:point][0], point[:point][1])
      Waypoint.create!(point)
    end
  end

  def format
    { "point":
        { "lat": point.x, "lng": point.y },
      "time": time,
      "name": name }
  end
end
