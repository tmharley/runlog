class AddIsNightToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :is_night, :boolean
  end
end
