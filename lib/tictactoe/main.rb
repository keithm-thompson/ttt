require_relative "game.rb"
require_relative "tictactoe_io.rb"

class Main
  def self.start_game
    TicTacToeIO.greet
    grid_len = TicTacToeIO.get_grid_length
    player1 = get_player_information("first")
    player2 = get_player_information("second" ,false)
    game = Game.new(grid_len, player1, player2)
    play(game)
  end

  def self.get_player_information(player, get_mark = true)
    puts "The following information is for the #{player} player."
    name = TicTacToeIO.get_player_name
    type = TicTacToeIO.get_player_type
    mark = TicTacToeIO.get_player_mark if get_mark

    { name: name, type: type, mark: mark }
  end

  def self.play(game)
    until game.over?
      play_round(game)
    end
    TicTacToeIO.display_results(game.winner)
    game.display_current_state

    start_game if TicTacToeIO.play_again?
  end

  def self.play_round(game)
    TicTacToeIO.display_beginning_of_round(game.current_player)
    game.display_current_state
    game.play_round
  end
end

Main.start_game unless ENV['RUBY_ENV'] == 'test'
