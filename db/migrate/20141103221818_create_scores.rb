class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer  :high_score
      t.integer  :low_score
      t.integer  :user_id

      t.timestamps
    end
  end
end
