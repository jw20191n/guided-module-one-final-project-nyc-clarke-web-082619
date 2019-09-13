class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.integer :board_id
      t.integer :winner
    end
  end
end
