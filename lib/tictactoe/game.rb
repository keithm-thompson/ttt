require_relative './board.rb'
require_relative './players/human_player.rb'
require_relative './players/computer_player.rb'

# EXPLAIN WIN CONDITION

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

  attr_reader :current_player
  def initialize(grid_len, player1, player2)
    @board = Board.new(grid_len)
    @player1 = Game.create_player(@board, player1)
    @player2 = Game.create_player(2board, player2)
    @current_player = [@player1, @player2].sample #randomly select who goes first
    @is_over = false
    @winner = nil
    @sums = {
      row_sums: Array.new(grid_len, 0),
      col_sums: Array.new(grid_len, 0),
      diag_sums: { back_slash: 0, forward_slash: 0}
    }
    @winning_value = grid_len
  end

  def is_over?
    @is_over
  end

  def play_round
    move, mark = @current_player.get_move, @current_player.mark
    @board.mark(move, mark)
    record_mark!(move, mark)
    swap_players!
  end



  private
  def game_over!
    @is_over = true
    set_winner!
  end

  def winning_move?(*sums)
    is_winning_move = false
    sums.each do |sum|
      is_winning_move = true if sum.abs == @winning_value
    end
    is_winning_move
  end

  def record_mark!(move, value)
    row, col = move[0], move[1]
    @sums[row_sums[row]] += value
    @sums[col_sums[col]] += value
    @sums[diag_sums.back_slash] += value if on_diagonal?("back", move)
    @sums[diag_sums.forward_slash] += value if on_diagonal?("forward", move)

    game_over! if winning_move?(row_sum, col_sum, back_diag_sum, front_diag_sum)
  end

  def set_winner!
    @winner = @current_player
  end

  def swap_players!
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

end
