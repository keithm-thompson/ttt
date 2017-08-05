require 'set'

class TicTacToeIO
  MARKS = Set.new(['X', 'x', 'O', 'o'])

  VALUES_TO_MARKS = {
    -1 => 'O',
    0 => ' ',
    1 => 'X'
  }

  def self.display_results(winner)
    if winner
      display_winner(winner.name)
    else
      display_tie
    end
  end

  def self.display_beginning_of_round(current_player)
    puts "It's #{current_player.name}'s turn. Good luck!"
  end

  def self.get_move_from_player(grid_len)
    puts "Please input two numbers less than #{grid_len} separated by a comma i.e 0,0"
    move = gets.chomp
    until self.class.valid_move_input?(move, grid_len)
      self.class.notify_invalid_input
      puts "Please input two numbers less than #{grid_len} separated by a comma i.e 0,0"
      move = gets.chomp
    end
    move
  end

  def self.get_player_mark
    puts "Please input X or O to claim a mark for this player."
    mark = gets.chomp
    until self.class.valid_mark?(mark)
      self.class.notify_invalid_input
      puts "Please input X or O to claim a mark for this player."
      mark = gets.chomp
    end
    mark
  end

  def self.get_player_name
    puts "Please input a name for this player."
    name = gets.chomp
    name
  end

  def self.get_player_type
    puts "Would you like for this player to be a computer player? Y or N"
    computer = gets.chomp
    until self.class.valid_player_type?(computer)
      self.class.notify_invalid_input
      puts "Would you like for this player to be a computer player? Y or N"
      computer = gets.chomp
    end
    computer == 'Y' ? "computer" : "human"
  end

  def self.get_grid_length
    puts "Please input the number of spaces that you like to be in each row."
    grid_len = gets.chomp
    until self.class.valid_grid_length?(grid_len)
      self.class.notify_invalid_input
      puts "Please input the number of spaces that you like to be in each row."
      grid_len = gets.chomp
    end
    grid_len.to_i
  end

  def self.greet
    puts "Time to play TicTacToe!"
  end

  def self.notify_invalid_move
    puts "Oops! Looks that point on the grid has already been played."
  end

  def self.print_border(length)
    puts " " + Array.new(length ,"- -").join(" ")
  end

  def self.print_row(row)
    output = "|"
    row.each do |val|
      output.concat(" " + VALUES_TO_MARKS[val] + " |")
    end
    puts output
  end

  private
  def display_winner(name)
    puts "#{name} wins! Good job!"
  end

  def display_tie
    puts "The game ended in a tie! Well played."
  end

  def self.notify_invalid_input
    puts "Oops! Looks like that input was invalid."
  end

  def self.valid_grid_length?(grid_len)
    Integer(grid_len || '')
    # add the || condition because Integer(nil) raises TypeError instead of ArgumentError
    rescue ArgumentError
      false
    end
    true
  end

  def self.valid_mark?(mark)
    MARKS.include?(mark)
  end

  def self.valid_move_input?(input, grid_len)
    first, second, *rest = input.split(",")
    is_first_valid = first.a? Integer && first < grid_len
    is_second_valid = second.is_a? Integer && second < grid_len

    is_first_valid && is_second_valid && rest.empty?
  end
end
