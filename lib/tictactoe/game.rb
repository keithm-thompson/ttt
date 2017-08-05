require_relative './board.rb'
require_relative './players/human_player.rb'
require_relative './players/computer_player.rb'

# I have mapped the values of the marks to either -1 or 1 to make checking for a
# win condition easier. Instead of iterating through the board and seeing
# if every space is occupied by the same mark, I will simply keep track
# of the sums of each row, col and the two diagonals. If at any point
# the absolute value of the sum is equal to the length of the grid, that
# satisfies a win condition

class Game
  MARKS_TO_VALUES = {
    'X' => 1,
    'x' => 1,
    'O' => -1,
    'o' => -1
  }
  OPPOSITE_MARK = {
    1 => 'O',
    -1 => 'X'
  }

  def self.create_player(board, player)
    type, name, mark = player.values_at(:type, :name, :mark)
    type === "human" ? HumanPlayer.new(name, MARKS_TO_VALUES[mark], board) : ComputerPlayer.new(name, MARKS_TO_VALUES[mark], board)
  end

  attr_reader :current_player, :winner, :board
  def initialize(grid_len, player1, player2)
    @board = Board.new(grid_len)

    @player1 = Game.create_player(@board, player1)
    player2[:mark] = OPPOSITE_MARK[@player1.mark]
    @player2 = Game.create_player(@board, player2)

    @current_player = [@player1, @player2].sample #randomly select who goes first
    @is_over = false
    @winner = nil
    @sums = {
      row_sums: Array.new(grid_len, 0),
      col_sums: Array.new(grid_len, 0),
      diag_sums: { back_slash: 0, forward_slash: 0}
    }
    @row_length = grid_len
  end

  def display_current_state
    @board.print
  end

  def over?
    @is_over
  end

  def play_round
    move, mark = @current_player.get_move, @current_player.mark
    @board.mark!(move, mark)
    record_mark!(move, mark)
    swap_players!
  end

  private
  def game_over!
    @is_over = true
  end

  def on_diagonal?(type, move)
    row, col = move[0], move[1]
    return row == col if type == "back"
    return (@row_length - row - 1) == col if type == "forward"
  end

  def record_mark!(move, value)
    row, col = move[0], move[1]
    @sums[:row_sums][row] += value
    @sums[:col_sums][col] += value
    @sums[:diag_sums][:back_slash] += value if on_diagonal?("back", move)
    @sums[:diag_sums][:forward_slash] += value if on_diagonal?("forward", move)

    set_winner! if winning_move?(
                                @sums[:row_sums][row],
                                @sums[:col_sums][col],
                                @sums[:diag_sums][:back_slash],
                                @sums[:diag_sums][:forward_slash]
                                )

    game_over! if @board.filled?
  end

  def set_winner!
    @winner = @current_player
    game_over!
  end

  def swap_players!
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def winning_move?(*sums)
    is_winning_move = false
    sums.each do |sum|
      is_winning_move = true if sum.abs == @row_length
    end
    is_winning_move
  end

end
