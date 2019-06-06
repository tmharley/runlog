class AddHeartRateToRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :heart_rate, :integer
  end
end
