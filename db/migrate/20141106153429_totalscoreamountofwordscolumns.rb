class Totalscoreamountofwordscolumns < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :total_score, :integer
    add_column :users, :words_guessed, :integer
  end
end
