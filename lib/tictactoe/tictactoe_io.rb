require 'set'

class TicTacToeIO
  MARKS = Set.new(['X', 'x', 'O', 'o'])

  VALUES_TO_MARKS = {
    -1 => 'O',
    0 => ' ',
    1 => 'X'
  }

  def self.class.get_mark_for_first_player(name)
    puts "#{name}, please input X or O to claim a mark."
    mark = gets.chomp
    until self.class.valid_mark?(mark)
      self.class.notify_invalid_input
      puts "#{name}, please input X or O to claim a mark."
      mark = gets.chomp
    end
    mark
  end

  def self.class.get_move_from_player(grid_len)
    puts "Please input two numbers less than #{grid_len} separated by a comma i.e 0,0"
    move = gets.chomp
    until self.class.valid_move_input?(move, grid_len)
      self.class.notify_invalid_input
      puts "Please input two numbers less than #{grid_len} separated by a comma i.e 0,0"
      move = gets.chomp
    end
    move
  end

  def self.class.get_name(player)
    puts "Please input a name for #{player}."
    name = gets.chomp
    name
  end

  def self.class.get_number_of_human_players
    puts "Please input 0, 1, or 2 to signify how many people are playing."
    num = gets.chomp
    until self.class.valid_num_players?(num)
      self.class.notify_invalid_input
      puts "Please input 0, 1, or 2 to signify how many people are playing."
      num = gets.chomp
    end
    num
  end

  def self.class.notify_invalid_move
    puts "Oops! Looks that point on the grid has already been played."
  end

  def self.class.print_border(length)
    puts " " + Array.new(length ,"- -").join(" ")
  end

  def self.class.print_row(row)
    output = "|"
    row.each do |val|
      output.concat(" " + VALUES_TO_MARKS[val] + " |")
    end
    puts output
  end

  private
  def self.class.notify_invalid_input
    puts "Oops! Looks like that input was invalid."
  end

  def valid_mark?(mark)
    MARKS.include?(mark)
  end

  def self.class.valid_move_input?(input, grid_len)
    first, second, *rest = input.split(",")
    is_first_valid = first.a? Integer && first < grid_len
    is_second_valid = second.is_a? Integer && second < grid_len

    is_first_valid && is_second_valid && rest.empty?
  end

  def valid_num_players?(num_players)
    num_players = Integer(num_players || '')
    # add the || condition because Integer(nil) raises TypeError instead of ArgumentError
    num_players.between?(0,2)
  rescue ArgumentError
    false
  end
end
