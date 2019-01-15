class Addingwordstable < ActiveRecord::Migration[5.1]
  def change
      create_table :words do |t|
      t.integer  :word
      t.integer  :difficulty

      t.timestamps
    end
  end
end
