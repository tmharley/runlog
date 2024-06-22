class AddRetiredToShoes < ActiveRecord::Migration[6.0]
  def change
    add_column :shoes, :retired, :boolean, default: false
  end
end
