require 'fighter'

class Boxer
  def initialize(player, boss, name="juuuuuuuuuuj")
    @player = player
    if ki?
      if rand(3) == 0
        name = $vokale[rand(18)]
        buchstabe = $konsonanten[rand(61)]
        name += buchstabe
        index = rand($konsonantenfolger[buchstabe].length)
        name += $konsonantenfolger[buchstabe][index] if rand(3) == 0 and index.is_a? Integer
      else
        name = $konsonanten[rand(61)]
      end
      3.times do
        buchstabe = $vokale[rand($vokale.length)]
        name += buchstabe
        name += $vokalfolger[buchstabe] if rand(3) == 0
        buchstabe = $konsonanten[rand($konsonanten.length)]
        name += buchstabe
        index = rand($konsonantenfolger[buchstabe].length)
        name += $konsonantenfolger[buchstabe][index] if rand(3) == 0 and index.is_a? Integer
      end
      name.capitalize!
    end
    @boss = boss
    @name = name.to_s
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
    @b = ""
    @s = ""
    @t = ""
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

  def human_trainer?
    self.class == Trainer && human?
  end

  def human?
    @player.human?
  end

  def ki?
    not human?
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
      puts "#{@name} ha#{@s}t keine Lust dazu." if human?
      return
    end
    if @konzentration < 10
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um SEILZUSPRINGEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 15
      puts "#{@name} #{@b}ist zu müde dazu!" if human?
      return
    end
    if @gewicht > (@kraft * 10)
      puts "#{@name} #{@b}ist zu schwer und zu schwach um Seilzuspringen." if human?
      return
    end
    @kondition += ((rand(5) + 1)/20.0)
    @kondition += @aufwaermen/10.0
    @aufwaermen += rand(2)
    @gewicht -= (rand(100)/1000.0)
    @freude -= (rand(30)/10.0)
    @hunger += rand(5)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/10.0
    puts "#{@name} spring#{@s}t Seil und ha#{@s}t nun mehr Kondition." if human?
  end
  def rennen
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if human?
      return
    end
    if @konzentration < 10
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu RENNEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 20
      puts "#{@name} #{@b}ist zu müde dazu!" if human?
      return
    end
    if @gewicht > (@kraft * 10)
      puts "#{@name} #{@b}ist zu schwer und zu schwach um zu rennen." if human?
      return
    end
    @kondition += ((rand(3) + 1)/20.0)
    @kondition += @aufwaermen/10.0
    @aufwaermen += rand(5)
    @gewicht -= (rand(200)/1000.0)
    @hunger += rand(7)
    @muedigkeit -= rand(5)
    @freude -= (rand(50)/10.0)
    @dehnbarkeit += rand(10)/10.0
    print "#{@name} renn#{@s}t und rennt, bis " if human?
    if @boss == self
      print "du" if human?
    else
      print "er" if human?
    end
    puts" nicht mehr kann#{@s}#{@t}!" if human?
  end
  def essen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 5
      puts "#{@name} ist zu müde dazu!" if human?
      return
    end
    if @geld < 70
      puts "#{@name} hat ja gar kein Geld! Er darf nicht essen! Rrraus!!" if human?
      return
    end
    @gewicht += ((rand(3) + rand(3))/10.0) if @hunger > 10
    @geld -= rand(70) if @hunger > 10
    puts "Mampf, mjam, schleck, mmh!" if human? and @hunger > 10
    puts "Bääh, kein Hunger!" if human? and @hunger <= 10
    @hunger -= rand(20) if @hunger > 10
  end
  def inkbsackb
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if human?
      return
    end
    if @konzentration < 15
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 10
      puts "#{@name} #{@b}ist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 2
      puts "#{@name} #{@b}ist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if human?
      return
    end
    @schnelligkeit += (rand(5)/10.0)
    @schnelligkeit += @aufwaermen/10.0
    @gewicht -= (rand(100)/1000.0)
    @aufwaermen += rand(10)/20.0
    @hunger += rand(3)
    @muedigkeit -= rand(3)
    @freude -= (rand(25)/10.0)
    @dehnbarkeit += rand(5)/10.0
    puts "Bum..bubum..bubum..bubum ..bumbum..bum..bubum..." if human?
  end
  def ingbsackb
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if human?
      return
    end
    if @konzentration < 13
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 15
      puts "#{@name} #{@b}ist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 2
      puts "#{@name} #{@b}ist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if human?
      return
    end
    @staerke += (rand(5)/50.0)
    @staerke += @aufwaermen/50.0
    @gewicht -= (rand(200)/1000.0)
    @aufwaermen += rand(20)/20.0
    @hunger += rand(5)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/50.0
    puts "DASCH!!.....BUMM!!..BASCH!....DONNER!!!..WUMM!!." if human?
  end
  def krafttraining
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if human?
      return
    end
    if @konzentration < 10
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um KRAFTTRAINING ZU MACHEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 25
      puts "#{@name} #{@b}ist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 2
      puts "#{@name} #{@b}ist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if human?
      return
    end
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
    puts "#{@name} macht Krafttraining. Nachher ist er natürlich hungrig und müde." if human?
  end
  def dehnen
    if @freude < 20
      puts "#{@name} ha#{@s}t keine Lust dazu." if human?
      return
    end
    if @konzentration < 15
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu DEHNEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 10
      puts "#{@name} #{@b}ist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 4
      puts "#{@name} #{@b}ist zu wenig aufgewärmt dazu." if human?
      return
    end
    if @dehnbarkeit < 2
      puts "Die Dehnbarkeitsstufe ist zu niedrig." if human?
      return
    end
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
    print "#{@name} dehn#{@s}t. " if human?
    print "Du" if equal?(@boss) and human?
    print "Er" if not equal?(@boss) and human?
    print " ha#{@s}t nun alles mögliche besser" if human?
    print ", aber Spass macht ihm das gar nicht" if human? and not equal?(@boss)
    puts "." if human?
  end
  def yoga
    if @freude < 5
      puts "#{@name} ha#{@s}t keine Lust dazu." if human?
      return
    end
    if @konzentration < 20
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!" if human?
      return
    end  
    if @muedigkeit < 10
      puts "#{@name} #{@b}ist zu müde dazu!" if human?
      return
    end
    @konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
    @konzentrationsfaehigkeit += rand(200) / 100.0
    puts "#{@name} mach#{@s}t komische Konzentrationsübungen." if human?
  end
  def zauberer
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @freude < 5
      puts "#{@name} möchte nicht zum Zauberer gehen." if human?
      return
    end
    if @konzentration < 18
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um DEM ZAUBERER ZUZUHÖREN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @geld < 70
      puts "DuUUUU wiLLLst MicH betRRügen? DUhasSSST ja Gar kEin gEld." if human?
      puts "DafÜÜr laSSTet mein Fluch AB jETzt auf dIIER." if human?
      puts "#{@name} hat nun sehr grosse Angst und ist psychisch völlig fertig." if human?
      @motivation = 0
      @freude = 0
    end
    if @muedigkeit < 10
      puts "#{@name} ist zu müde dazu!" if human?
      return
    end
    @motivation += (rand(21)/10.0) if @motivation < 100
    @geld -= rand(70)
    puts "SooOo meIN SoHn, dUUUUU bist aLsOO traurig? Dannn zuber ich dich gutt. NuN biSt dUUU dea BAÄSTE!" if human?
  end
  def filmschaun
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 15
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um EINEN FILM ZU SCHAUEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 5
      puts "#{@name} ist zu müde dazu!" if human?
      return
    end
    if @boss.geld < 70
      puts "Du hast ja gar kein Geld! Du darfst nicht ins Kino! Rrraus!!" if human?
      return
    end
    if @geld < 70
      puts "#{@name} hat ja gar kein Geld! Er darf nicht ins Kino! Rrraus!!" if human?
      return
    end
    @geld -= rand(70)
    @boss.geld -= rand(70)
    @freude += rand(21)
    puts "Der Film gefällt dem Boxer sehr. Dir ist er eigentlich zu doof. Das hat natürlich auch seinen Preis: Der Eintritt ist teuer." if human?
  end
  def schlafen
    @freude = ((@freude + rand(100))/2.0)
    @konzentration = (@konzentrationsfaehigkeit*5 + rand(@konzentrationsfaehigkeit*5))/10.0
    @muedigkeit += (rand(50) + rand(50)) if @muedigkeit < 30
    @muedigkeit = ((@muedigkeit + rand(100))/2.0) if @muedigkeit >= 30
    @gewicht -= (rand(500)/1000.0)
    @aufwaermen = 0
    @dehnbarkeit = 0
    @hunger += rand(10)
    puts "Chrr Zzz!" if human?
    puts "#{@name} ha#{@s}t nun geschlafen, #{@b}ist aber auch hungriger geworden." if human?
  end
  def testen
    puts "Konditionsstufe: #{@kondition}"
    puts "Gewicht: #{@gewicht} kg"
    puts "Schnelligkeitsstufe: #{@schnelligkeit}"
    puts "Geld: #{@geld}.00 Fr."
    puts "Kraftstufe: #{@kraft}"
    puts "Stärkestufe: #{@staerke}"
    puts "Aufgewärmtheitsstufe: #{@aufwaermen}"
    puts "Motivationsstufe: #{@motivation}"
    puts "Konzentrationsstufe: #{@konzentration}"
    puts "Konzentrationsfaehigkeitsstufe: #{@konzentrationsfaehigkeit}"
    puts "Freude: #{@freude}"
    puts "Hunger: #{@hunger}"
    puts "Dehnbarkeitsstufe: #{@dehnbarkeit}"
    puts "Wachheitsstufe: #{@muedigkeit}"
    w = @waffen.join ", "
    w = "keine" if @waffen == []
    puts "magische Boxhandschuhe: #{w}"
    a = @amulette.join ", "
    a = "keine" if @amulette == []
    puts "Amulette: #{a}"
    puts "Pokale: #{@pokal}"
  end
  def fkessen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 5
      puts "#{@name} ist zu müde dazu!" if human?
      return
    end
    if @geld < 700
      puts "#{@name} hat ja gar kein Geld! Er darf nicht essen! Rrraus!!" if human?
      return
    end
    @gewicht += ((rand(12) + rand(12))/10.0) if @hunger > 10
    @geld -= rand(700) + 30 if @hunger > 10
    puts "mmh! leckaschmecka!! mehr!" if human? and @hunger > 10
    puts "OOH! WAAS??!! DAS SOLL DER PREIS SEIN!!?? NIE WIEDER!!" if human? and @hunger > 10
    puts "Bääh, kein Hunger!" if human? and @hunger <= 10
    @hunger -= rand(30) if @hunger > 10
  end
  def duell(other, *args)
    own_fighter = Fighter.new(self)
    other_fighter = Fighter.new(other)
    own_fighter.duell(other_fighter, *args)
  end
end
