# Implemented to enforce that the player sub-classes implement the necessary methods
# The plan is to use duck_typing so that the game isn't concered with what types of players are playing

class BasePlayer
  def mark
    raise NotImplementedError, "You must allow mark to be publicly readable"
  end

  def name
    raise NotImplementedError, "You must allow name to be publicly readable"
  end

  def get_move
    raise NotImplementedError, "You must implement the get_move method"
  end
end
