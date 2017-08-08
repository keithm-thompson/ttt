OPPOSITE_MARKS = {
  1 => -1,
  -1 => 1
}

class TicTacToeNode
  attr_reader :config, :mark
  attr_accessor :num_losing_descendants, :num_winning_descendants

  def initialize(config, mark)
    @config = config
    @mark = mark
    @num_losing_descendants = 0
    @num_winning_descendants = 0
    @length = config.length
    @winner = nil
  end

  def generate_children
    children = []
    potential_config = @config.deep_dup
    @length.times do |num1|
      @length.times do |num2|
        if potential_config[num1][num2].zero?
          potential_config[num1][num2] = @mark
          new_node = TicTacToeNode.new(potential_config, OPPOSITE_MARKS[@mark])
          children << new_node
          potential_config = @config.deep_dup
        end
      end
    end
    children
  end

  def compare(other, adj)
    comparision = nil
    adj[self].each do |child|
      comparision = 1 if child.winner?
    end

    adj[other].each do |child|
      comparision = -1 if child.winner?
    end

    return comparision if comparision

    if (@num_losing_descendants < other.num_losing_descendants)
      -1
    else
      1
    end
  end

  def extract_diff(other)
    diff = []
    @length.times do |num1|
      @length.times do |num2|
        if @config[num1][num2].zero? && (not other.config[num1][num2].zero?)
          diff = [num1, num2]
        end
      end
    end
    diff
  end

  def ==(other)
    @config==other.config || @config == other
  end

  def eql?(other)
    self==other
  end

  def hash
    @config.hash
  end

  def over?
    filled? || winner?
  end

  def filled?
    @config.flatten.select(&:zero?).empty?
  end

  def winner?
    @winner ||= row_completed? || col_completed? || diag_completed?
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
      @length.times do |num|
        completed = true if @config.map{|row| row[num]}.inject(0, :+).abs == @length.times
      end
      completed
    end

    def diag_completed?
      incremental_counter, decremental_counter, forward_sum, backward_sum = 0, @length - 1, 0, 0
      @config.each do |row|
        forward_sum += row[incremental_counter]
        backward_sum += row[decremental_counter]
        incremental_counter += 1
        decremental_counter -= 1
      end
      forward_sum.abs == @length || backward_sum.abs == @length
    end
end



class TicTacToeGraph
  attr_reader :adjacency_list
  def initialize(grid_len, initial_config, mark)
    @adjacency_list = Hash.new { }
    create_configurations!(initial_config, mark) #BFS SEARCH GRAPH
    get_descendants(@adjacency_list.keys[0])
  end

  def get_next_move(config, mark)
    node = TicTacToeNode.new(config, mark)
    winner = nil
    @adjacency_list[node].each do |child|
      winner = child if child.winner?
    end
    new_node = winner || @adjacency_list[node].sort { |a,b| a.compare(b, @adjacency_list) }.first
    get_move(node, new_node)
  end


  private
  def create_configurations!(initial_config, mark)
    frontier = [TicTacToeNode.new(initial_config, mark)]
    until frontier.empty?
      next_nodes = []
      frontier.each do |node|
        unless @adjacency_list[node]
          @adjacency_list[node] = []
          children = node.generate_children unless node.over?
          next_nodes.concat(children || [])
          @adjacency_list[node] = children
        end
      end
      frontier = next_nodes
    end
  end

  def get_descendants(node)
    if @adjacency_list[node].nil?
      return 0
    end

    @adjacency_list[node].each do |child|
      if child.over?
        node.num_winning_descendants += 1
      else
        get_descendants(child)
        node.num_winning_descendants += child.num_losing_descendants
        node.num_losing_descendants += child.num_winning_descendants
      end
    end
    0
  end

  def get_move(old_node, new_node)
    old_node.extract_diff(new_node)
  end
end

class Array
  # monkey patch a deep dup for two dimentional arrays
  def deep_dup
    deep_clone = []
    self.each do |row|
      deep_clone << row.clone
    end
    deep_clone
  end
end
