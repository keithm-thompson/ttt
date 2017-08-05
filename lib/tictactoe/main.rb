require_relative "game.rb"
require_relative "tictactoe_io.rb"

def start_game
  TicTacToeIO.greeting
  grid_len = TicTacToeIO.get_grid_length
  player1, player2 = get_player_information
  game = Game.new(grid_len, player1, player2)
  play(game)
end

def play_round(game)
  TicTacToeIO.display_round_info(game.current_player)
  game.play_round
end

def play(game)
  until game.over?
    play_round(game)
  end
  TicTacToeIO.display_winner(game.winner)

  start_game if TicTacToeIO.play_again?
end

start_game()
