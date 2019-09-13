class Tictactoe

    attr_accessor :user1, :user2, :board, :winning_combinations, :board_instance, :game_instance

    def initialize (user1,user2)
        @user1 = user1
        @user2 = user2
        @board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        @winning_combinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        @board_instance = Board.create(state: @board.join) 
        @game_instance = Game.create(player1_id: user1.id, player2_id: user2.id, board_id: board_instance.id)
    end

    def display_board()
        puts "┌───────────┐".green
        puts "│".green +  " #{board[0]} " + "│".green + " #{board[1]} " + "│".green + " #{board[2]} " + "│".green
        puts "│-----------│".green
        puts "│".green +  " #{board[3]} " + "│".green + " #{board[4]} " + "│".green + " #{board[5]} " + "│".green
        puts "│-----------│".green
        puts "│".green +  " #{board[6]} " + "│".green + " #{board[7]} " + "│".green + " #{board[8]} " + "│".green
        puts "└───────────┘".green
    end 


    def input_to_index(user_input)
        user_input.to_i - 1
    end

    def position_taken?(input)
        board[input] == " " ? false : true
    end

    def valid_move?(input) 
        !position_taken?(input) && input >= 0 && input <= 8   
    end

    def move (input, turn = "X")    
        board[input] = turn
    end

    def turn(turn = "X") 
        turn = current_player
        puts "\n"
        if turn == "X"
            puts "#{user1.user_name}'s turn, please make a move. Type in number  1 - 9:"
        else
            puts "#{user2.user_name}'s turn, please make a move. Type in number  1 - 9:"
        end
        inputs  = gets.chomp
        index = input_to_index(inputs)


        while !valid_move?(index)  do 
            puts "Wrong input! please type in number 1 - 9"
            inputs  = gets.chomp
            index = input_to_index(inputs)
        end

        move(index, turn)
        puts "\n"
        display_board
    end

    def current_player
        turn_count.even? ? "X" : "O" 
    end

    def turn_with_dumb_computer(turn = "") 
        # turn = current_player
        index = rand(1..9)
        puts "\n"
        while !valid_move?(index)  do 
            index = input_to_index(rand(1..9))
        end

        move(index,turn)
        display_board
    end  

    def turn_with_medium_computer(turn) 
        index_x = []
        index_o = []
        difference = []
        index = 0
        intersection_x = []
        intersection_o = []

        board.each_with_index do |position,index|
            if position == "X" 
                index_x << index
            elsif position == "O"
                index_o << index
            end
        end

        winning_combinations.each do |array|
            intersection_x = index_x & array
            intersection_o = index_o & array 
            if turn == "O"
                if intersection_o.length == 2
                    difference = array - intersection_o
                    index = difference[0].to_i

                    if valid_move?(index)
                        break
                    end
                elsif intersection_x.length == 2
                    difference = array - intersection_x
                    index = difference[0].to_i
                    if valid_move?(index)
                        break
                    end
                end
            else
                if intersection_x.length == 2
                    difference = array - intersection_x
                    index = difference[0].to_i
                    if valid_move?(index)
                        break
                    end
                elsif intersection_o.length == 2
                    difference = array - intersection_o
                    index = difference[0].to_i
                    if valid_move?(index)
                        break
                    end
                end
            end
        end
            
        while !valid_move?(index) do
            index = rand(0..8)
        end

        move(index,turn)
        display_board
    end  

    def turn_count
        board.length - board.count(" ")
    end

    def won?
        index_x = []
        index_o = []

        board.each_with_index do |position,index|
            if position == "X" 
                index_x << index
            elsif position == "O"
                index_o << index
            end  
        end

        winning_combinations.each do |item|
            if item == index_x & item || item == index_o & item
                return true
            end
        end
        false;
    end

    def full?
        !board.include?(" ")
    end

    def draw?
        full? && !won?
    end

    def over?
        draw? || won?
    end

    def winning_player    
        winning_user = !turn_count.even? ? user1 : user2
        winning_user.increment!(:total_wins,1)
        game_instance.update(winner: winning_user.id)
        winning_user.user_name
    end

    def winner
        puts "#{winning_player} has won".red   
    end

    def draw
        puts "its a draw".red
    end

    def play
        user1.increment!(:total_games_played,1)
        user2.increment!(:total_games_played,1) 

        while !over?
            turn 
        end
        if won?
            winner
        else
            user1.increment!(:total_draws,1)
            user2.increment!(:total_draws,1)
            draw
        end
        board_instance.update(state:board.join)
    end

    def play_dumb_computer(player_turn) 
        user1.increment!(:total_games_played,1)
        user2.increment!(:total_games_played,1)
        if player_turn
            while !over?
                if current_player() == "X"
                    turn()
                else 
                    puts "computer makes a move: "
                    turn_with_dumb_computer("O")
                end
            end
            if won?
                winner 
            else
                user1.increment!(:total_draws,1)
                user2.increment!(:total_draws,1)
                draw
            end
        else
            while !over?
                if current_player() == "X"
                    puts "computer makes a move"
                    turn_with_dumb_computer("X")
                else 
                    turn()
                end
            end
            if won?
                winner 
            else
                user1.increment!(:total_draws,1)
                user2.increment!(:total_draws,1)
                draw
            end
        end

        board_instance.update(state:board.join)
    end

    def play_medium_computer(play_turn) 
        user1.increment!(:total_games_played,1)
        user2.increment!(:total_games_played,1)
        if (play_turn)
            while !over?
                if current_player() == "X"
                    turn()
                else 
                    puts "computer made a move"
                    turn_with_medium_computer("O")
                end
            end

            if won?
                winner 
            else
                user1.increment!(:total_draws,1)
                user2.increment!(:total_draws,1)
                draw
            end
        else
            while !over?
                if current_player() == "X"
                    puts "computer made a move"
                    turn_with_medium_computer("X")
                else 
                    turn()
                end
            end
            if won?
                winner 
            else
                user1.increment!(:total_draws,1)
                user2.increment!(:total_draws,1)
                draw
            end
        end
        board_instance.update(state:board.join)
    end

    def play_hard_computer(play_turn) 
        user1.increment!(:total_games_played,1)
        user2.increment!(:total_games_played,1)
        if (play_turn)
            while !over?
                if current_player() == "X"
                    turn()
                else 
                    puts "computer made a move"
                    turn_with_hard_computer("O")
                end
            end

            if won?
                winner 
            else
                user1.increment!(:total_draws,1)
                user2.increment!(:total_draws,1)
                draw
            end
        else
            while !over?
                if current_player() == "X"
                    puts "computer made a move"
                    turn_with_hard_computer("X")
                else 
                    turn()
                end
            end
            if won?
                winner 
            else
                user1.increment!(:total_draws,1)
                user2.increment!(:total_draws,1)
                draw
            end
        end
        board_instance.update(state:board.join)
    end

    def turn_with_hard_computer(turn) 
        index_x = []
        index_o = []
        difference = []
        index = 0
        intersection_x = []
        intersection_o = []

        board.each_with_index do |position,index|
            if position == "X" 
                index_x << index
            elsif position == "O"
                index_o << index
            end
        end

        winning_combinations.each do |array|
            intersection_x = index_x & array
            intersection_o = index_o & array 
            if turn == "O"                      # computer is second
                if intersection_o.length == 2
                    difference = array - intersection_o
                    index = difference[0].to_i

                    if valid_move?(index)
                        break
                    end
                elsif intersection_x.length == 2
                    difference = array - intersection_x
                    index = difference[0].to_i
                    if valid_move?(index)
                        break
                    end
                end
            else                                # computer starts   
                if intersection_x.length == 2
                    difference = array - intersection_x
                    index = difference[0].to_i
                    if valid_move?(index)
                        break
                    end
                elsif intersection_o.length == 2
                    difference = array - intersection_o
                    index = difference[0].to_i
                    if valid_move?(index)
                        break
                    end
                end
            end
        end
            
        while !valid_move?(index) do
            index = rand(0..8)
        end

        move(index,turn)
        display_board
    end  


    def clear
        board = Array.new(9, " ")
    end



end