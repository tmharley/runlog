class AddHumidityAndIntensityToRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :humidity, :integer
    add_column :runs, :intensity, :decimal
  end
end
