require 'ai_player'

class AIPlayer2 < AIPlayer
  def boxer_runde(boxer)
    boxer.seilspringen
    if rand(5) == 0
      boxer.zauberer
      boxer.rennen if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.fkessen
      boxer.fkessen if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.seilspringen 
      boxer.seilspringen if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.essen
      boxer.essen if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.filmschaun
      boxer.filmschaun if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.inkbsackb
      boxer.inkbsackb if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.ingbsackb
      boxer.ingbsackb if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.krafttraining
      boxer.krafttraining if @name == "Igel" or @name == "Hase"
    elsif rand(5) == 0
      boxer.rennen
      boxer.rennen if @name == "Igel" or @name == "Hase"
    end
    boxer.dehnen if @name == "Igel" or @name == "Hase"
  end
end
