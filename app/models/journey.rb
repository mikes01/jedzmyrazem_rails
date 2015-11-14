# Model for manage journeys
class Journey < ActiveRecord::Base
  belongs_to :driver, class_name: 'User', foreign_key: :driver_id
end
