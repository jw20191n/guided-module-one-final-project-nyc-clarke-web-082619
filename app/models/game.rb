class Game < ActiveRecord::Base
    belongs_to :player1, class_name: 'User', foreign_key: :player1_id
    belongs_to :player2, class_name: 'User', foreign_key: :player2_id
    belongs_to :board
end