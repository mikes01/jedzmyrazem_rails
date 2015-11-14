class CreateJourneys < ActiveRecord::Migration
  def change
    create_table :journeys do |t|
      t.references :driver, null: false, index: true
      t.date :date, null: false, index: true
      t.integer :spaces, null: false
      t.timestamps null: false
    end
  end
end
