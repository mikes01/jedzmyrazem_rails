# Model for manage waypoints of journey
class Waypoint < ActiveRecord::Base
  belongs_to :journey
end
