# Implemented to enforce that the player sub-classes implement the necessary methods
# The plan is to use duck_typing so that the game isn't concered with what types of players are playing

class BasePlayer
  def perform_move
    raise NotImplementedError, "You must implement the perform_move method"
  end

  def mark
    raise NotImplementedError, "You must allow mark to be readable"
  end
end
