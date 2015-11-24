class AddNameToWaypoint < ActiveRecord::Migration
  def up
    add_column :waypoints, :name, :string, null: false, default: 'name'
  end

  def down
    remove_column :waypoints, :name
  end
end
