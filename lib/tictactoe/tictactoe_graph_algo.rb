OPPOSITE_MARKS = {
  1 => -1,
  -1 => 1
}

class TicTacToeNode
  attr_reader :config, :mark
  attr_accessor :num_losing_descendants, :num_winning_descendants,
                :checked_descendants, :guaranteed_loser, :winner

  def initialize(config, mark)
    @config = config
    @mark = mark
    @num_losing_descendants = 0
    @num_winning_descendants = 0
    @length = config.length
    @winner = nil
    @guaranteed_loser = nil
    @filled = nil
    @checked_descendants = false
  end

  def generate_children
    children = []
    potential_config = @config.deep_dup
    @length.times do |row|
      @length.times do |col|
        if potential_config[row][col].zero?
          potential_config[row][col] = @mark
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

    unless comparision.nil?
      return comparision
    end

    if (@num_winning_descendants > other.num_winning_descendants)
      1
    else
      -1
    end
  end

  def extract_diff(other)
    diff = []
    @length.times do |row|
      @length.times do |col|
        if @config[row][col].zero? && (not other.config[row][col].zero?)
          diff = [row, col]
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
    @filled ||= @config.flatten.select(&:zero?).empty?
  end

  def winner?
    @winner ||= row_completed? || col_completed? || diag_completed?
  end

  private
    def row_completed?
      completed = false
      @config.each do |row|
        completed = true if row.inject(0, :+).abs == @length
      end
      completed
    end

    def col_completed?
      completed = false
      @length.times do |num|
        completed = true if @config.map{|row| row[num]}.inject(0, :+).abs == @length
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
    create_configurations!(initial_config, mark)
    get_descendants(@adjacency_list.keys[0])
  end

  def get_next_move(config, mark)
    node = TicTacToeNode.new(config, mark)
    winner = nil
    @adjacency_list[node].each do |child|
      winner = child if child.winner?
    end
    new_node = winner || non_losing(node)
    get_move(node, new_node)
  end


  private
  #BFS SEARCH GRAPH
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
    return 0 if node.checked_descendants
    node.checked_descendants = true

    if @adjacency_list[node].nil?
      return 0
    end

    num_guaranteed_losing_children = 0
    @adjacency_list[node].each do |child|
      if child.winner?
        node.num_winning_descendants += 1
        node.guaranteed_loser = true
      else
        get_descendants(child)
        node.num_winning_descendants += child.num_losing_descendants
        node.num_losing_descendants += child.num_winning_descendants
      end

      if child.guaranteed_loser.nil?
        if (guaranteed_loser?(child))
          num_guaranteed_losing_children += 1
        end
      else
        num_guaranteed_losing_children += 1 if child.guaranteed_loser
      end
    end

    if (num_guaranteed_losing_children == @adjacency_list[node].length)
      node.winner = true
    end
    0
  end

  def get_move(old_node, new_node)
    old_node.extract_diff(new_node)
  end

  def non_losing(node)
    is_non_losing = false
    next_move = nil
    @adjacency_list[node].sort { |a,b| a.compare(b, @adjacency_list) }.each do |move|
      next unless @adjacency_list[move]
      unless (move.guaranteed_loser)
        next_move = move
        break
      end
    end
    next_move or @adjacency_list[node].first
  end

  def guaranteed_loser?(child)
    return false if @adjacency_list[child].nil?

    guaranteed_loser = false
    @adjacency_list[child].each do |grand_child|
      if (grand_child.winner?)
        guaranteed_loser = true
        break
      end
    end
    return guaranteed_loser
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
