require_relative './board.rb'
require_relative './players/human_player.rb'
require_relative './players/computer_player.rb'

# EXPLAIN

class Game
  MARKS_TO_VALUES = {
    'X' => 1,
    'x' => 1,
    'O' => -1,
    'o' => -1
  }

  def self.create_player(board, type, mark)
    type === "human" ? HumanPlayer.new(board, MARKS_TO_VALUES[mark]) : ComputerPlayer.new(board, MARKS_TO_VALUES[mark])
  end

  def initialize(grid_len, player1, player2)
    @board = Board.new(grid_len)
    @player1 = Game.create_player(@board, player1.type, player1.mark)
    @player2 = Game.create_player(2board, player2.type, player2.mark)
  end
end
