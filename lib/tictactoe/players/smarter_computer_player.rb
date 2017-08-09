require_relative '../tictactoe_graph_algo.rb'
require_relative '../tictactoe_io.rb'

class SmarterComputerPlayer < ComputerPlayer
  attr_reader :mark, :name
  def initialize(name, mark, board)
    super(name, mark, board)
    @graph = nil
  end

  def get_move
    if @graph
      @graph.get_next_move(@board.grid, @mark)
    elsif can_make_graph?
      TicTacToeIO.notify_creating_graph
      @graph = TicTacToeGraph.new(@board.length, @board.grid, @mark)
      get_move
    else
      move = choose_non_losing_move
      super if move.empty?
      move
    end
  end

private
  def can_make_graph?
    @board.available_spots.length < 12
  end

  def choose_non_losing_move
    node = TicTacToeNode.new(@board.grid, @mark)
    poss_moves = node.generate_children
    next_move = []
    poss_moves.shuffle.each do |move|
      two_step_moves = move.generate_children
      is_move_safe = two_step_moves.select { |tsm| tsm.winner? }
      is_move_safe = is_move_safe.empty?
      if (is_move_safe)
        next_move = node.extract_diff(move)
        break
      end
    end
    next_move
  end
end
