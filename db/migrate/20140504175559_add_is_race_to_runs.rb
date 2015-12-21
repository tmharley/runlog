class AddIsRaceToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :is_race, :boolean
  end
end
