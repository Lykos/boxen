require 'boxer'

class Trainer < Boxer
  def initialize(player, eignername, name=1)
    @player = player
    @boss = self
    @name = eignername
    @kondition = 0
    @gewicht = 70.0 + rand(30)
    @schnelligkeit = 0
    @geld = rand(20000)
    @kraft = (@gewicht/10.0)
    @staerke = 0
    @aufwaermen = 0
    @konzentration = rand(50)
    @hunger = 0
    @muedigkeit = rand(50)
    @dehnbarkeit = 0
    @konzentrationsfaehigkeit = 40
    @motivation = 0
    @heraus = 1
    @freude = 1000
    @waffen = []
    @wkosten = []
    @amulette = []
    @akosten = []
    if @name == "Elch"
      @kondition = 2
      @schnelligkeit = 2
      @geld = rand(30000)
      @kraft += 1
      @staerke = 2
      @aufwaermen = 2
      @motivation = 10
    end
  end

  def runde
    @freude = 1000
    @motivation = 0
    @heraus = 1
    @hunger += (rand(20)/10.0)
    @konzentration -= (rand(200)/20.0) if @muedigkeit < 25
    @konzentration -= rand(100)/10.0
    @konzentration += rand(100)/10.0
    @muedigkeit -= rand(5)
    @staerke += @muedigkeit / (rand(1000) + 1.0)
    @geld += 100
    return :starved if @gewicht < 50 or @hunger > 60
    return :sleeps if @muedigkeit < 1
  end
  def seilspringen
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
    elsif @konzentration < 10
      boxer_message(:no_concentration, :rope_jump)
    elsif @muedigkeit < 15
      boxer_message(:too_tired)
    elsif @gewicht > (@kraft * 10)
      boxer_message(:too_weak, :rope_jump)
    else
      boxer_message(:trainer_rope_jump)
      @kondition += ((rand(5) + 1)/100.0)
      @kondition += @aufwaermen/50.0
      @aufwaermen += rand(2)
      @gewicht -= (rand(100)/1000.0)
      @hunger += rand(5)
      @muedigkeit -= rand(5)
      @dehnbarkeit += rand(10)/10.0
    end
  end
  def rennen
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
    elsif @konzentration < 10
      boxer_message(:no_concentration, :run)
    elsif @muedigkeit < 20
      boxer_message(:too_tired)
    elsif @gewicht > (@kraft * 10)
      boxer_message(:too_weak, :run)
    else
      boxer_message(:trainer_run)
      @kondition += ((rand(3) + 1)/100.0)
      @kondition += @aufwaermen/50.0
      @aufwaermen += rand(5)
      @gewicht -= (rand(200)/1000.0)
      @hunger += rand(7)
      @muedigkeit -= rand(5)
      @dehnbarkeit += rand(10)/10.0
    end
  end
  def essen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      boxer_message(:no_concentration, :eat)
    elsif @muedigkeit < 5
      boxer_message(:too_tired)
    elsif @geld < 70
      boxer_message(:no_eat_money)
    elsif @hunger <= 10
      boxer_message(:trainer_no_hunger)
    else
      boxer_message(:trainer_eat)
      @gewicht += ((rand(3) + rand(3))/10.0)
      @geld -= rand(70)
      @hunger -= rand(20)
    end
  end
  def inkbsackb
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
    elsif @konzentration < 15
      boxer_message(:no_concentration, :small_sack)
    elsif @muedigkeit < 10
      boxer_message(:too_tired)
    elsif @aufwaermen < 2
      boxer_message(:not_warmed_up)
    else
      boxer_message(:trainer_small_sack)
      @schnelligkeit += (rand(5)/50.0)
      @schnelligkeit += @aufwaermen/50.0
      @gewicht -= (rand(100)/1000.0)
      @aufwaermen += rand(20)/10.0
      @hunger += rand(3)
      @muedigkeit -= rand(3)
      @dehnbarkeit += rand(5)/10.0
    end
  end
  def ingbsackb
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
    elsif @konzentration < 13
      boxer_message(:no_concentration, :big_sack)
    elsif @muedigkeit < 15
      boxer_message(:too_tired)
    elsif @aufwaermen < 2
      boxer_message(:not_warmed_up)
    else
      boxer_message(:trainer_big_sack)
      @staerke += (rand(5)/50.0)
      @staerke += @aufwaermen/50.0
      @gewicht -= (rand(200)/1000.0)
      @aufwaermen += rand(20)/20.0
      @hunger += rand(5)
      @muedigkeit -= rand(5)
      @dehnbarkeit += rand(10)/10.0
    end
  end
  def krafttraining
    if @kraft > 15 and @staerke > 5 and @kondition > 5
      super
    elsif @konzentration < 10
      boxer_message(:no_concentration, :strength_training)
    elsif @muedigkeit < 25
      boxer_message(:too_tired)
    elsif @aufwaermen < 2
      boxer_message(:not_warmed_up)
    else
      boxer_message(:trainer_strength_training)
      @kondition += (rand(10)/100.0)
      @kondition += @aufwaermen/50.0
      @kraft += (rand(10)/50.0)
      @kraft += @aufwaermen/50.0
      @staerke += (rand(10)/50.0)
      @staerke += @aufwaermen/50.0
      @gewicht -= (rand(400)/1000.0)
      @aufwaermen += rand(40)/20.0
      @hunger += rand(10)
      @muedigkeit -= rand(10)
      @dehnbarkeit += rand(10)/10.0
    end
  end
  def dehnen
    if @konzentration < 15
      boxer_message(:no_concentration, :strength_training)
    elsif @muedigkeit < 10
      boxer_message(:too_tired)
    elsif @aufwaermen < 4
      boxer_message(:not_warmed_up)
    elsif @dehnbarkeit < 2
      boxer_message(:no_stretch)
    else
      boxer_message(:stretch)
      @aufwaermen += rand(3)
      @aufwaermen += rand(5) if @aufwaermen > 5
      @aufwaermen += @aufwaermen / 10.0 if @aufwaermen > 7
      @aufwaermen += @dehnbarkeit / 10.0
      @kondition +=  (rand(5)/100.0) if @aufwaermen > 5
      @kondition += @aufwaermen/50.0 if @aufwaermen > 7
      @kondition += @dehnbarkeit/15.0
      3.times do
        @dehnbarkeit -= rand(2)
        break if @dehnbarkeit == 0
      end
    end
  end
  def yoga
    if @konzentration < 20
      boxer_message(:not_concentrated_enough)
    elsif @muedigkeit < 10
      boxer_message(:too_tired)
    else
      boxer_message(:yoga)
      @konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
      @konzentrationsfaehigkeit += rand(200) / 100.0
    end
  end

  def testen
    @player.manager.ttesten(self)
  end
  
  def fkessen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      boxer_message(:no_concentration)
    elsif @muedigkeit < 5
      boxer_message(:too_tired)
    elsif @geld < 700
      boxer_message(:no_eat_money)
    elsif @hunger <= 10
      boxer_message(:trainer_no_hunger)
    else
      boxer_message(:trainer_eat_kaviar)
      @gewicht += ((rand(12) + rand(12))/10.0)
      @geld -= rand(700) + 30
      @hunger -= rand(30)
    end
  end
end
