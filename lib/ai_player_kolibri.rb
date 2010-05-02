require 'ai_player'

class AIPlayerKolibri < AIPlayer
  def boxer_runde(boxer)
    c = rand(100)
    if boxer.motivation < 2 and boxer.freude < 20
      boxer.schlafen
    end
    if boxer.konzentration < 10
      boxer.schlafen
    end
    if boxer.gewicht < 55 and not boxer.geld < 1000 and not boxer.hunger < 11
      boxer.fkessen
    elsif boxer.gewicht < 55 and not boxer.geld < 100 and not boxer.hunger < 11
      boxer.essen
    end
    if boxer.hunger > 10 and not boxer.geld < 3000 and boxer.aufwaermen == 0
      boxer.fkessen
    elsif boxer.hunger > 10 and not boxer.geld < 100 and boxer.aufwaermen == 0
      boxer.essen
    end
    if boxer.freude < 55 and not boxer.geld < 1000 and not boxer.konzentration < 11 and boxer.aufwaermen == 0
      boxer.filmschaun
    elsif boxer.freude < 10
      boxer.schlafen
    end  
    if boxer.konzentration < 20
      boxer.schlafen
    end
    if boxer.motivation < 8 and boxer.freude < 20
      boxer.filmschaun
      c = 3
    end
    if boxer.motivation < 10 and boxer.muedigkeit < 20 and boxer.aufwaermen == 0
      c = 3
    end
    if boxer.konzentration < boxer.konzentrationsfaehigkeit and boxer.aufwaermen == 0 and rand(2) == 0
      boxer.yoga
    end
    if boxer.muedigkeit < 10
      boxer.schlafen
    end
    if boxer.aufwaermen > 5 and boxer.dehnbarkeit > 2 and boxer.muedigkeit > 10
      boxer.dehnen
    end
    if c < 5 and boxer.aufwaermen == 0 and boxer.muedigkeit > 5 and boxer.konzentration > 18
      boxer.zauberer
    elsif c < 15 and boxer.aufwaermen == 0 and boxer.muedigkeit > 5 and boxer.konzentration > 20
      boxer.yoga
    elsif c < 25 and not boxer.geld < 1000 and not boxer.hunger < 15 and not boxer.gewicht > 150 and boxer.aufwaermen == 0 and boxer.muedigkeit > 5 and boxer.konzentration > 10
      boxer.fkessen
    elsif c < 30 and not boxer.geld < 100 and not boxer.hunger < 15 and not boxer.gewicht > 155 and boxer.aufwaermen == 0 and boxer.muedigkeit > 5 and boxer.konzentration > 10
      boxer.essen
    elsif c < 40 and boxer.muedigkeit > 15 and boxer.konzentration > 10
      boxer.seilspringen
    elsif c < 50 and not boxer.aufwaermen < 3 and boxer.muedigkeit > 25 and boxer.konzentration > 10
      boxer.krafttraining
    elsif c < 60 and not boxer.aufwaermen < 3 and boxer.muedigkeit > 15 and boxer.konzentration > 13
      boxer.inkbsackb
    elsif c < 70 and not boxer.aufwaermen < 3 and boxer.muedigkeit > 10 and boxer.konzentration > 15
      boxer.inkbsackb
    elsif c < 100 and not boxer.aufwaermen > 7 and boxer.muedigkeit > 20 and boxer.konzentration > 10
      boxer.rennen
    elsif not boxer.muedigkeit > 10 and boxer.konzentration > 15
      boxer.inkbsackb
    else
      boxer.schlafen
    end
  end
end
