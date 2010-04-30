require 'ai_player'

class AIPlayer3 < AIPlayer
  def boxer_runde(boxer)
    if boxer.aufwaermen == 0 and boxer.muedigkeit < 40
      if boxer.muedigkeit > 5 and boxer.geld > 100 and boxer.konzentration > 15 and boxer.boss.geld > 100 and boxer.freude < 20
        boxer.filmschaun
      elsif boxer.hunger > 10 and boxer.geld > 1000 and boxer.konzentration > 5 and boxer.muedigkeit > 5
        boxer.fkessen
      elsif boxer.hunger > 10 and boxer.konzentration > 5 and boxer.geld > 100 and boxer.muedigkeit > 5
        boxer.essen
      elsif boxer.muedigkeit > 10 and boxer.konzentration > 20 and boxer.freude > 5 and rand(3) == 0
        boxer.yoga
      elsif boxer.motivation < 5 and boxer.muedigkeit > 10 and boxer.konzentration > 18 and boxer.freude > 5
        boxer.zauberer
      elsif boxer.muedigkeit > 10 and boxer.konzentration > 18 and boxer.freude > 5 and rand(3) == 0
        boxer.zauberer
      elsif boxer.muedigkeit > 10 and boxer.konzentration > 20 and boxer.freude > 5
        boxer.yoga
      else
        boxer.schlafen
      end
    elsif boxer.aufwaermen < 2
      if boxer.geld > 100 and boxer.konzentration > 15 and boxer.boss.geld > 100 and boxer.freude < boxer.muedigkeit - 20 and boxer.muedigkeit > 60
        boxer.filmschaun
      elsif boxer.geld > 100 and boxer.konzentration > 15 and boxer.boss.geld > 100 and boxer.freude < boxer.muedigkeit - 10
        boxer.filmschaun
      elsif boxer.hunger > 10 and boxer.geld > 1000 and boxer.konzentration > 5
        boxer.fkessen
      elsif boxer.hunger > 10 and boxer.konzentration > 5
        boxer.essen
      elsif boxer.konzentration > 20 and boxer.freude > 5 and boxer.konzentration < boxer.muedigkeit - 30 and rand(2) == 0
        boxer.yoga
      elsif boxer.konzentration > 20 and boxer.freude > 5 and boxer.konzentration < boxer.muedigkeit - 40
        boxer.yoga
      elsif boxer.konzentration > 10 and boxer.freude > 10
        boxer.rennen
      else
        boxer.schlafen
      end
    else
      if boxer.dehnbarkeit > 2 and boxer.konzentration > 15 and boxer.freude > 20 and boxer.aufwaermen > 4 and boxer.muedigkeit > 10
        boxer.dehnen
      elsif boxer.dehnbarkeit > 2 and boxer.konzentration > 15 and boxer.freude > 20 and boxer.muedigkeit > 20
        boxer.rennen
      elsif boxer.dehnbarkeit > 2 and boxer.konzentration > 15 and boxer.freude > 20 and boxer.muedigkeit > 15
        boxer.rennen
      elsif boxer.staerke % 10 < 5 and boxer.muedigkeit > 15 and boxer.konzentration > 10 and boxer.freude > 10
        if rand(4) == 0 or boxer.muedigkeit < 25 and not boxer.konzentration < 13
          boxer.ingbsackb
        else
          boxer.krafttraining
        end
      elsif boxer.muedigkeit > 15 and boxer.konzentration > 10 and boxer.freude > 10 and rand(3) == 0
        if rand(4) == 0 or boxer.muedigkeit < 25 and not boxer.konzentration < 13
          boxer.ingbsackb
        else
          boxer.krafttraining
        end
      elsif boxer.muedigkeit > 10 and boxer.konzentration > 15 and boxer.freude > 10
        boxer.inkbsackb
      elsif boxer.muedigkeit > 5 and boxer.geld > 100 and boxer.konzentration > 15 and boxer.boss.geld > 100 and boxer.freude < 20
        boxer.filmschaun
      elsif boxer.hunger > 10 and boxer.geld > 1000 and boxer.konzentration > 5 and boxer.muedigkeit > 5
        boxer.fkessen
      elsif boxer.hunger > 10 and boxer.konzentration > 5 and boxer.geld > 100 and boxer.muedigkeit > 5
        boxer.essen
      else
        boxer.schlafen
      end
    end
  end
end
