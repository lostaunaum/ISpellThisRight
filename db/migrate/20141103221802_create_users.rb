class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name

      t.string   :description
      t.string   :location
      t.string   :nickname
      t.string   :score

      t.timestamps
    end
  end
end
