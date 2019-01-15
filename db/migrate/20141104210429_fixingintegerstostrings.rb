class Fixingintegerstostrings < ActiveRecord::Migration[5.1]
  def change
    change_table :words do |t|
      t.change :word, :string
      t.change :difficulty  , :string
    end
  end
end
