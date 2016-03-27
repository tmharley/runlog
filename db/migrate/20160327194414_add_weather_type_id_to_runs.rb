class AddWeatherTypeIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :weather_type_id, :integer
  end
end
