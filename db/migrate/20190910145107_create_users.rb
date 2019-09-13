class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.integer :total_wins
      t.integer :total_games_played
      t.integer :total_draws
    end
  end
end
