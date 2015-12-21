class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.datetime :start_time
      t.decimal :distance
      t.integer :duration
      t.integer :temperature
      t.integer :elev_gain

      t.timestamps
    end
  end
end
