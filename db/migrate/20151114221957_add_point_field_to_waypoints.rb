class AddPointFieldToWaypoints < ActiveRecord::Migration
  def change
    add_column :waypoints, :point, :st_point, geographic: true, null: false
  end
end
