class Fixingintegerstostrings < ActiveRecord::Migration
  def change
    change_table :words do |t|
      t.change :word, :string
      t.change :difficulty  , :string
    end
  end
end
