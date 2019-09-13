require_relative '../config/environment'
require_relative '../app/models/board.rb'
require_relative '../app/models/game.rb'
require_relative '../app/models/user.rb'
require 'pry'
require_relative 'tictactoe.rb'
require 'tty-prompt'


ActiveRecord::Base.logger = nil
prompt = TTY::Prompt.new
system 'clear'

def screen_message
    puts "               _                          "
    puts " __      _____| | ___ ___  _ __ ___   ___ "
    puts " \\ \\ /\\ / / _ \\ |/ __/ _ \\| '_ ` _ \\ / _ \\"
    puts "  \\ V  V /  __/ | (_| (_) | | | | | |  __/"
    puts "   \\_/\\_/ \\___|_|\\___\\___/|_| |_| |_|\\___|"
    puts "                    _        "
    puts "                   | |_ ___  "
    puts "                   | __/ _ \\ "
    puts "                   | || (_) |"
    puts "                    \\__\\___/ "
    puts "  _   _        _               _ "
    puts " | |_(_) ___  | |_ __ _  ___  | |_ ___   ___ "
    puts " | __| |/ __| | __/ _` |/ __| | __/ _ \\ / _ \\"
    puts " | |_| | (__  | || (_| | (__  | || (_) |  __/"
    puts "  \\__|_|\\___|  \\__\\__,_|\\___|  \\__\\___//\\___|"
    puts "\n"
end

def user_in_db?(username)
    check = User.all.find {|user| user.user_name == username}
    check == nil ? false : true
end

def find_user(username)
    User.all.find {|user| user.user_name == username}
end

def statistics(user)
    puts "*****************************************"
    puts "**"+"               #{user.user_name}                ". red + "**"
    puts "**     Total games played: #{user.total_games_played}           **"
    puts "**     Total wins: #{user.total_wins}                   **"
    puts "**     Total draws: #{user.total_draws}                  **"
    puts "**     Your winning rate is: #{(user.total_wins/user.total_games_played.to_f*100).round(2)}%    **"
    puts "*****************************************"
end

def login_signup_prompt(prompt)
    prompt_choice = prompt.select("", %w(login sign_up))
    user = User.new
    if prompt_choice == "login"                                 # login
        prompt_user = prompt.ask("Enter your username: ")
        while !user_in_db?(prompt_user) do
            prompt_user = prompt.ask("username doesn't exist, please retry: (CTRL + C to exit)")
        end 
        user = find_user(prompt_user)
        puts "\n"
        puts " ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ WELCOME BACK #{user.user_name}!!!!⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ".colorize(:black).colorize( :background => :light_blue)
        puts "\n"
    else                                                        # signup
        prompt_user = prompt.ask("Enter your username: ")
        while user_in_db?(prompt_user) do 
            prompt_user = prompt.ask("username already exist, please try another name: ")
        end
           user = User.create(user_name: prompt_user, total_wins: 0, total_games_played: 0, total_draws: 0)
           puts "#{user.user_name} created!"
    end
    user 
end

def find_computer(iq)
    User.all.find{|user| user.user_name == iq}    
end

def find_all_games(user)
    all_games = (user.player1_games  + user.player2_games).sort_by { |game| game.id }
    all_games.each do |game| 
        puts "\n"
        if game.player1_id == user.id
            puts "In game ID:#{game.id} You are 'X', your opponent is #{game.player2.user_name} "
            puts "\n"
        else
            puts "In game ID:#{game.id} Your are 'O', your opponent is #{game.player1.user_name} "
            puts "\n"
        end

        display_board(game.board.state.split(""))
        puts "\n"

        if game.winner != nil 
            winner = User.find(game.winner) 
            puts "The winner is #{winner.user_name}".red
            puts "\n"
            puts "============================================================".blue
        else
            puts "It's a draw".red
            puts "\n"
            puts "============================================================".blue
        end
    end
end

def display_board(board)
    puts "┌───────────┐".green
    puts "│".green +  " #{board[0]} " + "|".green + " #{board[1]} " + "|".green + " #{board[2]} " + "│".green
    puts "│-----------│".green
    puts "│".green +  " #{board[3]} " + "|".green + " #{board[4]} " + "|".green + " #{board[5]} " + "│".green
    puts "│-----------|".green
    puts "│".green +  " #{board[6]} " + "|".green + " #{board[7]} " + "|".green + " #{board[8]} " + "│".green
    puts "└───────────┘".green
end 

screen_message
user1 = login_signup_prompt(prompt)
bool = true
while bool do
    prompt.select("") do |menu|
    menu.choice 'play with computer', ->  {
        prompt.select("") do |menu|
  
            menu.choice 'easy', -> { 
                system 'clear'
                game = Tictactoe.new(user1,find_computer("dumb_computer"))
                game.display_board    
                player_turn = true
                game.play_dumb_computer(player_turn)
                while true
                    if prompt.yes?("Do you want to play another game?")
                        system 'clear'
                        if player_turn
                            game = Tictactoe.new(find_computer("dumb_computer"),user1)
                            player_turn = false
                            game.play_dumb_computer(player_turn)
                        else
                            game = Tictactoe.new(user1,find_computer("dumb_computer"))
                            player_turn = true
                            game.play_dumb_computer(player_turn)


                        end
                    else
                        break;
                    end
                end
            } 
            menu.choice 'medium', -> {
                system 'clear'
                game = Tictactoe.new(user1,find_computer("medium_computer"))
                game.display_board    
                player_turn = true
                game.play_medium_computer(player_turn)
                while true
                    if prompt.yes?("Do you want to play another game?")
                        system 'clear'
                        if player_turn
                            game = Tictactoe.new(find_computer("medium_computer"),user1)
                            player_turn = false
                            game.play_medium_computer(player_turn)
                        else
                            game = Tictactoe.new(user1,find_computer("medium_computer"))
                            player_turn = true
                            game.play_medium_computer(player_turn)
                        end
                    else
                        break;
                    end
                end
            }
            menu.choice 'hard', -> {
                
                # game = Tictactoe.new(user1,find_computer("medium_computer"))
                # game.display_board    
                # game.play_medium_computer
            } 
        end
    }
    menu.choice 'play against another player', -> {  
        system 'clear'
        user2 = login_signup_prompt(prompt)
        game = Tictactoe.new(user1,user2)
        game.display_board 
        game.play
        player_turn = true
        while true
            if prompt.yes?("Do you want to play another game?")
                system 'clear'
                if player_turn
                    game = Tictactoe.new(user2,user1)
                    player_turn = false
                else
                    game = Tictactoe.new(user1,user2)
                    player_turn = true
                end
                game.play
            else
                break;
            end
        end
    }
    # menu.choice 'challenge someone'
    # menu.choice 'see current games'
    menu.choice 'see all games', -> { find_all_games(user1) } 
    menu.choice 'statistics', -> { statistics(user1) }
    menu.choice 'exit', -> { bool = false } 
    end
end
