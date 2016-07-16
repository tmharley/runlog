class AddShoeAndWeatherIndexes < ActiveRecord::Migration
  def self.up
    add_index :runs, :shoe_id
    add_index :runs, :weather_type_id
  end

  def self.down
    remove_index :runs, :shoe_id
    remove_index :runs, :weather_type_id
  end
end
