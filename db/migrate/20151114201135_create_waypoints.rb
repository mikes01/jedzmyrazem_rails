class CreateWaypoints < ActiveRecord::Migration
  def change
    create_table :waypoints do |t|
      t.references :journey, null: false, index: true
      t.time :time, null: false
    end
  end
end
