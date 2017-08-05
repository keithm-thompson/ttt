# Implemented to enforce that the player sub-classes implement the same methods
# The plan is to use duck_typing so that the game isn't concered with what types of players are playing

class BasePlayer
  def perform_move
    raise NotImplementedError, "You must implement the perform_move method"
  end
end
