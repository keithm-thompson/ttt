require_relative "../io.rb"
require_relative "./base_player"

class HumanPlayer < BasePlayer
  attr_reader :mark
  def initialize(board, mark)
    @board = board
    @mark = mark
  end

  def perform_move
    move = self.get_move
    @board.mark(move, @mark)
  end

  private
  def get_move
    move_attempt = IO.get_move_from_player(@board.length)
    until @board.valid_move?(move_attempt)
      IO.notify_invalid_move
      move_attempt = IO.get_move_from_player(@board.length)
    end
    move_attempt
  end
end
