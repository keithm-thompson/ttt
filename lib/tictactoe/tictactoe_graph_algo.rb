OPPOSITE_MARKS = {
  1 => -1,
  -1 => 1
}

class TicTacToeNode
  attr_reader :num_winning_descendants, :children

  def initialize(config, mark)
    @config = config
    @mark = mark
    @num_winning_descendants = 0
    @children = generate_children unless over?
  end

  def increment_winning_descendants
    @num_winning_descendants += 1
  end

  def generate_children
    children = []
    potential_config = @config.deep_dup
    @config.length.times do |num1|
      @config.length.times do |num2|
        if potential_config[num1][num2].zero?
          potential_config[num1][num2] = @mark
          new_node = TicTacToeNode.new(potential_config, OPPOSITE_MARKS[@mark])
          children << new_node
          @num_winning_descendants += 1 if new_node.winner?
          @num_winning_descendants += new_node.num_winning_descendants
          potential_config = @config.deep_dup
        end
      end
    end
    children
  end

  def over?
    filled? || winner?
  end

  def filled?
    @config.flatten.select(&:zero?).empty?
  end

  def winner?
    row_completed? || col_completed? || diag_completed?
  end

  private
    def row_completed?
      completed = false
      @config.each do |row|
        completed = true if row.inject(0, :+).abs == row.length
      end
      completed
    end

    def col_completed?
      completed = false
      @config.length.times do |num|
        completed = true if @config.map{|row| row[num]}.inject(0, :+).abs == @config.length.times
      end
      completed
    end

    def diag_completed?
      incremental_counter, decremental_counter, forward_sum, backward_sum = 0, @config.length - 1, 0, 0
      @config.each do |row|
        forward_sum += row[incremental_counter]
        backward_sum += row[decremental_counter]
        incremental_counter += 1
        decremental_counter -= 1
      end
      forward_sum == @config.length || backward_sum == @config.length
    end
end



class TicTacToeGraph
  def initialize(grid_len)
    @initial_verticies = []

    create_configurations!
    @row_length = grid_len
  end


  private
  def create_configurations!
  end

  def get_connecting_nodes(node, mark)
  end
end

class Array
  # quick monkey patch a deep dup for two dimentional arrays
  def deep_dup
    deep_clone = []
    self.each do |row|
      deep_clone << row.clone
    end
    deep_clone
  end
end
