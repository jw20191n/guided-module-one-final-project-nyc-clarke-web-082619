class Board < ActiveRecord::Base
    has_one :game
    # belongs_to :player1, :class_name => 'User', through: :games, :foreign_key => 'player1_id'
    # belongs_to :player2, :class_name => 'User', through: :games, :foreign_key => 'player2_id'
end