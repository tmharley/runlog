class CreateWeatherTypes < ActiveRecord::Migration
  def change
    create_table :weather_types do |t|
      t.string :name
      t.boolean :is_precip

      t.timestamps
    end
  end
end
