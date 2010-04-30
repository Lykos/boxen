require 'fighter'
require 'forwardable'

class Boxer
  def initialize(player, boss, name="juuuuuuuuuuj")
    @player = player
    @name = name.to_s
    @name = generate_name if ki?
    @boss = boss
    @kondition = rand(11)       
    @gewicht = 70.0 + rand(30)   
    @schnelligkeit = rand(11)    
    @geld = rand(20000)       
    @staerke = rand(11)       
    @aufwaermen = 0         
    @motivation = 10       
    @konzentration = rand(50)
    @freude = rand(50)
    @hunger = 0
    @muedigkeit = rand(50)
    @dehnbarkeit = 0
    @konzentrationsfaehigkeit = 40
    @pokal = 0
    @heraus = 1
    @kraft = ((@gewicht/10.0)+2)
    @schnelligkeit += 2 if @name == "Bombana"
    @staerke += 10 if @name == "Bahnhof"
    @waffen = []
    @wkosten = []
    @amulette = []
    @akosten = []
    if @name == "King Box King"
      @staerke += 10
      @kraft += 2
      @kondition += 5
    elsif @name == "King Schlag King"
      @staerke += 5
      @kondition += 5
      @schnelligkeit += 1
      @kraft += 1
    elsif @name == "Schwabbel"
      @gewicht += rand(80)
      @kraft += 2 + rand(4) + rand(4)
    elsif @name == "King"
      @gewicht += rand(80)
      @kraft += 50
      @staerke += 50
      @kondition += 50
      @schnelligkeit += 50      
      @konzentrationsfaehigkeit = 100
    elsif @name == "usama" or @name == "Usama"
      @motivation += 10
      @staerke += 10      
    elsif @name == "Bombatschk"
      @motivation += 10
      @schnelligkeit = 0
      @staerke += 20
    end
  end

  attr_reader :boss, :konzentrationsfaehigkeit
  attr_accessor :name, :kondition, :kraft, :geld, :staerke, :aufwaermen, :motivation
  attr_accessor :konzentration, :schnelligkeit, :freude, :muedigkeit, :hunger, :gewicht
  attr_accessor :dehnbarkeit, :pokal, :heraus, :waffen, :amulette, :kosten

  extend Forwardable

  def human_trainer?
    self.class == Trainer && human?
  end

  def_delegators :@player, :human?, :message

  def boxer_message(*args)
    @player.boxer_message(@name, args)
  end
  
  def ki?
    not human?
  end

  def generate_name
    if rand(3) == 0
      @name = $vokale[rand(18)]
      buchstabe = $konsonanten[rand(61)]
      @name += buchstabe
      index = rand($konsonantenfolger[buchstabe].length)
      @name += $konsonantenfolger[buchstabe][index] if rand(3) == 0 and index.is_a? Integer
    else
      @name = $konsonanten[rand(61)]
    end
    3.times do
      buchstabe = $vokale[rand($vokale.length)]
      @name += buchstabe
      @name += $vokalfolger[buchstabe] if rand(3) == 0
      buchstabe = $konsonanten[rand($konsonanten.length)]
      @name += buchstabe
      index = rand($konsonantenfolger[buchstabe].length)
      @name += $konsonantenfolger[buchstabe][index] if rand(3) == 0 and index.is_a? Integer
    end
    @name.capitalize!
  end
  
  def runde
    @heraus = 1
    @hunger += (rand(20)/10.0)
    @motivation -= (rand(5)/20.0) if @freude < 20
    @konzentration -= (rand(200)/20.0) if @muedigkeit < 25
    @konzentration -= rand(100)/10.0
    @konzentration += rand(100)/10.0
    @freude -= rand(100)/10.0
    @freude += rand(100)/10.0
    @muedigkeit -= rand(5)
    @staerke += @muedigkeit / (rand(200) + 1.0)
    return :gives_up if @motivation < 0
    return :starved if @gewicht < 50 or @hunger > 60
    if @muedigkeit < 1
      schlafen
      return :sleeps
    end
    if @hunger > 40
      essen
      return :eats
    end
    if @freude < 1
      filmschaun
      return :cinema
    end
  end

  def seilspringen
    if @freude < 10
      boxer_message(:no_desire)
    elsif @konzentration < 10
      boxer_message(:no_concentration, :jump_rope)
    elsif @muedigkeit < 15
      boxer_message(:too_tired)
    elsif @gewicht > (@kraft * 10)
      boxer_message(:too_heavy)
    else
      @kondition += ((rand(5) + 1)/20.0)
      @kondition += @aufwaermen/10.0
      @aufwaermen += rand(2)
      @gewicht -= (rand(100)/1000.0)
      @freude -= (rand(30)/10.0)
      @hunger += rand(5)
      @muedigkeit -= rand(5)
      @dehnbarkeit += rand(10)/10.0
      boxer_message(:jump_rope)
    end
  end
  def rennen
    if @freude < 10
      boxer_message(:no_desire)
    elsif @konzentration < 10
      boxer_message(:no_concentration, :run)
    elsif @muedigkeit < 20
      boxer_message(:too_tired)
    elsif @gewicht > (@kraft * 10)
      boxer_message(:too_heavy)
    else
      boxer_message(:run)
      @kondition += ((rand(3) + 1)/20.0)
      @kondition += @aufwaermen/10.0
      @aufwaermen += rand(5)
      @gewicht -= (rand(200)/1000.0)
      @hunger += rand(7)
      @muedigkeit -= rand(5)
      @freude -= (rand(50)/10.0)
      @dehnbarkeit += rand(10)/10.0
    end
  end
  def essen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      boxer_message(:no_concentration, :eat)
    elsif @muedigkeit < 5
      boxer_message(:eat)
    elsif @geld < 70
      boxer_message(:no_eat_money)
    elsif @hunger <= 10
      boxer_message(:no_hunger)
    else
      boxer_message(:eat)
      @gewicht += ((rand(3) + rand(3))/10.0)
      @geld -= rand(70)
      @hunger -= rand(20)
    end
  end
  def inkbsackb
    if @freude < 10
      boxer_message(:no_desire)
    elsif @konzentration < 15
      boxer_message(:no_concentration, :small_sack)
    elsif @muedigkeit < 10
      boxer_message(:too_tired)
    elsif @aufwaermen < 2
      boxer_message(:not_warmed_up)
    else
      boxer_message(:small_sack)
      @schnelligkeit += (rand(5)/10.0)
      @schnelligkeit += @aufwaermen/10.0
      @gewicht -= (rand(100)/1000.0)
      @aufwaermen += rand(10)/20.0
      @hunger += rand(3)
      @muedigkeit -= rand(3)
      @freude -= (rand(25)/10.0)
      @dehnbarkeit += rand(5)/10.0
    end
  end
  def ingbsackb
    if @freude < 10
      boxer_message(:no_desire)
    elsif @konzentration < 13
      boxer_message(:no_concentration, :big_sack)
    elsif @muedigkeit < 15
      boxer_message(:too_tired)
    elsif @aufwaermen < 2
      boxer_message(:not_warmed_up)
    else
      boxer_message(:big_sack)
      @staerke += (rand(5)/50.0)
      @staerke += @aufwaermen/50.0
      @gewicht -= (rand(200)/1000.0)
      @aufwaermen += rand(20)/20.0
      @hunger += rand(5)
      @muedigkeit -= rand(5)
      @dehnbarkeit += rand(10)/50.0
    end
  end
  def krafttraining
    if @freude < 10
      boxer_message(:no_desire)
    elsif @konzentration < 10
      boxer_message(:no_concentration, :strength_training)
    elsif @muedigkeit < 25
      boxer_message(:too_tired)
    elsif @aufwaermen < 2
      boxer_message(:not_warmed_up)
    else
      boxer_message(:strength_training)
      @kondition += (rand(10)/20.0)
      @kondition += @aufwaermen/10.0
      @kraft += (rand(10)/10.0)
      @kraft += @aufwaermen/10.0
      @staerke += (rand(10)/10.0)
      @staerke += @aufwaermen/10.0
      @gewicht -= (rand(400)/1000.0)
      @aufwaermen += rand(40)/20.0
      @hunger += rand(10)
      @muedigkeit -= rand(10)
      @freude -= (rand(70)/10.0)
      @dehnbarkeit += rand(10)/10.0
    end
  end

  def dehnen
    if @freude < 20
      boxer_message(:no_desire)
    elsif @konzentration < 15
      boxer_message(:no_concentration, :stretch)
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
      @kondition +=  (rand(5)/20.0) if @aufwaermen > 5
      @kondition += @aufwaermen/10.0 if @aufwaermen > 7
      @kondition += @dehnbarkeit/3.0
      3.times do
        @dehnbarkeit -= rand(2)
        break if @dehnbarkeit == 0
      end
      @freude -= (rand(100)/10.0)
    end
  end
  def yoga
    if @freude < 5
      boxer_message(:no_desire)
    elsif @konzentration < 20
      boxer_message(:not_concentrated_enough)
    elsif @muedigkeit < 10
      boxer_message(:too_tired)
    else
      boxer_message(:yoga)
      @konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
      @konzentrationsfaehigkeit += rand(200) / 100.0
    end
  end
  def zauberer
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @freude < 5
      boxer_message(:no_wizard_desire)
    elsif @konzentration < 18
      boxer_message(:no_concentration, :wizard)
    elsif @geld < 70
      boxer_message(:no_wizard_money)
      @motivation = 0
      @freude = 0
    elsif @muedigkeit < 10
      boxer_message(:too_tired)
    else
      @motivation += (rand(21)/10.0) if @motivation < 100
      @geld -= rand(70)
    end
  end
  
  def filmschaun
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 15
      boxer_message(:no_concentration)
    elsif @muedigkeit < 5
      boxer_message(:too_tired)
    elsif @boss.geld < 70
      boxer_message(:boss_no_film_money)
    elsif @geld < 70
      boxer_message(:no_film_money)
    else
      boxer_message(:film)
      @geld -= rand(70)
      @boss.geld -= rand(70)
      @freude += rand(21)
    end
  end
  def schlafen
    boxer_message(:sleep)
    @freude = ((@freude + rand(100))/2.0)
    @konzentration = (@konzentrationsfaehigkeit*5 + rand(@konzentrationsfaehigkeit*5))/10.0
    @muedigkeit += (rand(50) + rand(50)) if @muedigkeit < 30
    @muedigkeit = ((@muedigkeit + rand(100))/2.0) if @muedigkeit >= 30
    @gewicht -= (rand(500)/1000.0)
    @aufwaermen = 0
    @dehnbarkeit = 0
    @hunger += rand(10)
  end

  def fkessen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      boxer_message(:no_concentration, :eat)
    elsif @muedigkeit < 5
      boxer_message(:too_tired)
    elsif @geld < 700
      boxer_message(:no_eat_money)
    elsif @hunger <= 10
      boxer_message(:no_hunger)
    else
      boxer_message(:eat_kaviar)
      @gewicht += ((rand(12) + rand(12))/10.0)
      @geld -= rand(700) + 30
      @hunger -= rand(30)
    end
  end
  def duell(other, *args)
    own_fighter = Fighter.new(self)
    other_fighter = Fighter.new(other)
    own_fighter.duell(other_fighter, *args)
  end
end
