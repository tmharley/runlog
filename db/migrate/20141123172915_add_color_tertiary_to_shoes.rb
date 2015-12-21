class AddColorTertiaryToShoes < ActiveRecord::Migration
  def change
    add_column :shoes, :color_tertiary, :string
  end
end
