class AddPrecipToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :precip, :boolean
  end
end
