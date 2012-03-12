
# Represents the object which controls a player.
#
class PlayerManager

  attr_accessor :player
  attr_reader :name, :player, :trainer

  def player=(player)
    @player = player
    @boxer = @player.boxer
    @trainer = @player.trainer
    @name = @trainer.name
  end

  # Handles general notifications for the player.
  #
  def message(type, *args)
  end

  # Notifies that the boxers rounds now follow.
  #
  def start_boxers
  end
  
  # Handles notifications for the player about one specific boxer.
  #
  def boxer_message(name, type, *args)
  end
end
