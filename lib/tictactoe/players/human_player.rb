require_relative "../tictactoe_io.rb"
require_relative "./base_player"

class HumanPlayer < BasePlayer
  attr_reader :mark, :name
  def initialize(name, mark, board)
    @name = name
    @mark = mark
    @board = board
  end

  def get_move
    move_attempt = TicTacToeIO.get_move_from_player(@board.length)
    until @board.valid_move?(move_attempt)
      TicTacToeIO.notify_invalid_move
      move_attempt = TicTacToeIO.get_move_from_player(@board.length)
    end
    move_attempt
  end
end
