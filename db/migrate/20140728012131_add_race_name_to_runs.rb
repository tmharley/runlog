class AddRaceNameToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :race_name, :string
  end
end
