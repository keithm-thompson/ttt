require "byebug"
class IO
  VALUES_TO_MARKS = {
    -1 => 'O',
    0 => ' ',
    1 => 'X'
  }

  def self.get_move_from_player(grid_len)
    puts "Please input two numbers less than #{grid_len} separated by a comma i.e 0,0"
    move = gets
    until self.valid_input?(move, grid_len)
      self.notify_invalid_move_input
      move = gets
    end
    move
  end

  def self.notify_invalid_move
    puts "Oops! Looks that point on the grid has already been played."
  end

  def self.print_border(length)
    puts " " + Array.new(length ,"-").join(" ")
  end

  def self.print_row(row)
    output = "|"
    row.each do |val|
      output.concat(VALUES_TO_MARKS[val] + "|")
    end
    puts output
  end

  private
  def self.valid_input?(input, grid_len)
    first, second, *rest = input.split(",")
    is_first_valid = first.a? Integer && first < grid_len
    is_second_valid = second.is_a? Integer && second < grid_len

    is_first_valid && is_second_valid && rest.empty?
  end

  def self.notify_invalid_move_input
    puts "Oops! Looks like that input was invalid."
  end
end
