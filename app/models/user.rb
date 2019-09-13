class User < ActiveRecord::Base
    has_many :player1_games, :class_name => 'Game', :foreign_key => 'player1_id'
    has_many :player2_games , :class_name => 'Game', :foreign_key => 'player2_id'
end