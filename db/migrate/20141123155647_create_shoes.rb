class CreateShoes < ActiveRecord::Migration
  def change
    create_table :shoes do |t|
      t.string :manufacturer
      t.string :model
      t.string :color_primary
      t.string :color_secondary
      t.decimal :size

      t.timestamps
    end
  end
end
