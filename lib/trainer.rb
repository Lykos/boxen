require 'boxer'

class Trainer < Boxer
  def initialize(player, eignername, name=1)
    @player = player
    @boss = self
    @boxer = [Boxer.new(@player, self, name)]
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
    @b = "b"
    @s = "s"
    @t = "t"
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

  attr_reader :boxer

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
      return
    end
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um SEILZUSPRINGEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 15
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @gewicht > (@kraft * 10)
      puts "Du bist zu schwer und zu schwach um Seilzuspringen." if human?
      return
    end
    @kondition += ((rand(5) + 1)/100.0)
    @kondition += @aufwaermen/50.0
    @aufwaermen += rand(2)
    @gewicht -= (rand(100)/1000.0)
    @hunger += rand(5)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/10.0
    puts "Du probierst verzweifelt, seilzuspringen, schaffst es aber nie mehr als fünf Mal." if human?
  end
  def rennen
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu RENNEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 20
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @gewicht > (@kraft * 10)
      puts "Du bist zu schwer und zu schwach um zu rennen." if human?
      return
    end
    @kondition += ((rand(3) + 1)/100.0)
    @kondition += @aufwaermen/50.0
    @aufwaermen += rand(5)
    @gewicht -= (rand(200)/1000.0)
    @hunger += rand(7)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/10.0
    puts "Du joggst ein kleines Stückchen, dann fällst du um vor Müdigkeit." if human?
  end
  def essen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 5
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @geld < 70
      puts "Du hast ja gar kein Geld! Er darf nicht essen! Rrraus!!" if human?
      return
    end
    @gewicht += ((rand(3) + rand(3))/10.0) if @hunger > 10
    @geld -= rand(70) if @hunger > 10
    puts "Das Essen mundet dir sehr." if human? and @hunger > 10
    puts "Du hast aber keinen Hunger!" if human? and @hunger <= 10
    @hunger -= rand(20) if @hunger > 10
  end
  def inkbsackb
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 15
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 10
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 2
      puts "Du bist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if human?
      return
    end
    @schnelligkeit += (rand(5)/50.0)
    @schnelligkeit += @aufwaermen/50.0
    @gewicht -= (rand(100)/1000.0)
    @aufwaermen += rand(20)/10.0
    @hunger += rand(3)
    @muedigkeit -= rand(3)
    @dehnbarkeit += rand(5)/10.0
    puts "Bümmele..bübümmele..bübümmele..bübümmele ..bümmelebümmele..bümmele..bübümmele..." if human?
  end
  def ingbsackb
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 13
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 15
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 2
      puts "Du bist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if human?
      return
    end
    @staerke += (rand(5)/50.0)
    @staerke += @aufwaermen/50.0
    @gewicht -= (rand(200)/1000.0)
    @aufwaermen += rand(20)/20.0
    @hunger += rand(5)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/10.0
    puts "dong!.....batz!..döff!....doing!..." if human?
  end
  def krafttraining
    if @kraft > 15 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um KRAFTTRAINING ZU MACHEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 25
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 2
      puts "Du bist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if human?
      return
    end
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
    puts "Du machst natürlich leichteres Krafttraining als der Boxer, nach ein paar Liegestützen bist du schon völlig KO." if human?
  end
  def dehnen
    if @konzentration < 15
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu DEHNEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 10
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @aufwaermen < 4
      puts "Du bist zu wenig aufgewärmt dazu." if human?
      return
    end
    if @dehnbarkeit < 2
      puts "Deine Dehnbarkeitsstufe ist zu niedrig." if human?
      return
    end
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
    puts "Du dehnst." if human?
  end
  def yoga
    if @konzentration < 20
      puts "Du bist zu unkonzentriert dazu!" if human?
      return
    end  
    if @muedigkeit < 10
      puts "Du bist zu müde dazu!" if human?
      return
    end
    @konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
    @konzentrationsfaehigkeit += rand(200) / 100.0
    puts "Du machst komische Konzentrationsübungen." if human?
  end
  def testen
    puts "Konditionsstufe: #{@kondition}"
    puts "Gewicht: #{@gewicht} kg"
    puts "Schnelligkeitsstufe: #{@schnelligkeit}"
    puts "Geld: #{@geld}.00 Fr."
    puts "Kraftstufe: #{@kraft}"
    puts "Stärkestufe: #{@staerke}"
    puts "Aufgewärmtheitsstufe: #{@aufwaermen}"
    puts "Konzentrationsstufe: #{@konzentration}"
    puts "Konzentrationsfaehigkeitsstufe: #{@konzentrationsfaehigkeit}"
    puts "Hunger: #{@hunger}"
    puts "Dehnbarkeitsstufe: #{@dehnbarkeit}"
    puts "Wachheitsstufe: #{@muedigkeit}"
    print "Boxer: "
    self.boxer.each_with_index {|boxers,i| print boxers.name, ", " if i < self.boxer.length - 1}
    puts "#{self.boxer[-1].name} und natürlich #{@name} selbst."
  end
  def fkessen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if human?
      return
    end
    if @muedigkeit < 5
      puts "Du bist zu müde dazu!" if human?
      return
    end
    if @geld < 700
      puts "Du hast ja gar kein Geld! Du darfst nicht essen! Rrraus!!" if human?
      return
    end
    @gewicht += ((rand(12) + rand(12))/10.0) if @hunger > 10
    @geld -= rand(700) + 30 if @hunger > 10
    puts "Das Zeug ist dir eigentlich zu fettig, aber es muss sein." if human? and @hunger > 10
    puts "Du hast keinen Hunger!" if human? and @hunger <= 10
    @hunger -= rand(30) if @hunger > 10
  end
end
