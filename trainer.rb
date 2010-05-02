require 'boxer'

class Trainer < Boxer
  def initialize(player, eignername, kijn=1, name=1)
    @player = player
    @boss = self
    @boxer = [Boxer.new(@player, self, name, kijn)]
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
    @kijn = kijn
    @motivation = 0
    @heraus = 1
    @freude = 1000
    @s = ""
    @b = ""
    @t = ""
    @s = "s" if human_trainer?
    @b = "b" if human_trainer?
    @t = "t" if human_trainer?
    @s = ""
    @b = ""
    @t = ""
    @st = 0
    @ak = 0
    @init = 0
    @agr = 0
    @w = 0
    @wk = 0
    @hk = 0
    @lp = 0
    @kg = 0
    @rw = 0
    @alarm = 0
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

  attr_accessor :name, :motivation, :boxer, :kondition, :kraft, :geld, :staerke, :aufwaermen
  attr_accessor :konzentration, :schnelligkeit, :muedigkeit, :hunger, :gewicht, :dehnbarkeit
  attr_accessor :kijn, :heraus, :b, :s, :waffen, :waffent, :b, :s, :st, :ak, :init, :agr, :w
  attr_accessor :wk, :hk, :kg, :rw, :lp, :amulette, :kosten

  def ctrunde(i)
    if not @name == "Kolibri" or not rand(4) == 0
      $gegner[i] = Player.new(@name) if self.crunde == 1
    end
    if @name == "Elch"
      $gegner[i] = Player.new(@name) if self.crunde == 1
    end
    @boxer.each_with_index do |e, i|
      if i + 1 == @boxer.length
        @boxer.pop if e.crunde == 1
      else
        @boxer[i..-2] = @boxer[i + 1..-1] if e.crunde == 1
      end
    end
  end
  def trunde
    runde
    puts "_______________________________________________________________________________________________"
    puts
    puts "Die Runden deiner Boxer:"
    @boxer.each_with_index do |e, i|
      if i + 1 == boxer.length
        @boxer.pop if e.runde == 1
      else
        @boxer[i..-2] = @boxer[i + 1..-1] if e.runde == 1
      end
    end
  end
  def crunde
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
    puts "#{@name} ist verhungert. Es kommt ein neuer, gleichnamiger Boxertrainer." if @gewicht < 50
    return 1 if @gewicht < 50
    puts "#{@name} ist verhungert. Es kommt ein neuer, gleichnamiger Boxertrainer." if @hunger > 60
    return 1 if @hunger > 60
    if @muedigkeit < 1
      self.schlafen
      return 2
    end
    c = rand(100)
    self.schlafen if @konzentration < 20
    self.schlafen if @muedigkeit < 10
    if @geld > 6500
      self.boxerkaufen
      return 2
    end
    if @gewicht < 55 and not @geld < 1000 and not @hunger < 11
      self.fkessen
    elsif @gewicht < 55 and not @geld < 100 and not @hunger < 11
      self.essen
    end
    self.yoga if @konzentration < @konzentrationsfaehigkeit and @aufwaermen == 0 and rand(3) == 0
    if @hunger > 10 and not @geld < 5000 and @aufwaermen == 0
      self.fkessen
    elsif @hunger > 10 and not @geld < 100 and @aufwaermen == 0
      self.essen
    end
    self.dehnen if @aufwaermen > 5 and @dehnbarkeit > 2 and @muedigkeit > 10
    if c < 5 and @geld > 5000
      self.boxerkaufen
    elsif c < 15 and @aufwaermen == 0
      self.yoga
    elsif c < 25 and not @geld < 1000 and not @hunger < 15 and not @gewicht > 150 and @aufwaermen == 0
      self.fkessen
    elsif c < 30 and not @geld < 100 and not @hunger < 15 and not @gewicht > 155 and @aufwaermen == 0
      self.essen
    elsif c < 40
      self.seilspringen
    elsif c < 50 and not @aufwaermen < 3 and @muedigkeit > 25
      self.krafttraining
    elsif c < 60 and not @aufwaermen < 3 and @muedigkeit > 15
      self.inkbsackb
    elsif c < 70 and not @aufwaermen < 3 and @muedigkeit > 10
      self.inkbsackb
    elsif c < 100 and not @aufwaermen > 7 and @muedigkeit > 20
      self.rennen
    elsif not @muedigkeit > 10
      self.inkbsackb
    else
      self.schlafen
    end
  end
  def runde
    @freude = 1000
    @motivation = 0
    @heraus = 1
    @hunger += (rand(20)/10.0)
    @konzentration -= (rand(200)/20.0) if @muedigkeit < 20
    @konzentration -= rand(100)/10.0 - rand(100)/10.0
    @muedigkeit -= rand(5)
    @geld += rand(100)
    puts "Du bist verhungert." if @hunger > 60
    raise Interrupt if @hunger > 60
    puts "Du bist verhungert." if @gewicht < 50
    raise Interrupt if @gewicht < 50
    if @muedigkeit < 0
      puts "Du bist eingeschlafen."
      self.schlafen
      return 2
    end
    puts "_______________________________________________________________________________________________"
    puts
    puts "Deine Runde:"
    puts "_______________________________________________________________________________________________"
    puts
    self.testen
    puts "_______________________________________________________________________________________________"
    puts
    puts "1 = Seilspringen (Kondition)"
    puts "2 = Rennen (Kondition/Aufwärmen)"
    puts "3 = Essen (Gewicht)"
    puts "4 = In den kleinen Boxsack boxen (Schnelligkeit)"
    puts "5 = In den grossen Boxsack boxen (Stärke)"
    puts "6 = Krafttraining (Kraft, Stärke, Kondition)"
    puts "8 = Dehnen (Alles mögliche)"
    puts "9 = Yoga (Konzentration)"
    puts "12 = Testen (genau wissen, wie gut er ist)"
    puts "13 = Aufhören (Nicht mehr zusehen müssen, wie der Compi viel besser ist als du(!!!!))"
    puts "14 = Fettige sachen und Kaviar Essen (Gewicht)"
    puts "15 = Schlafen (Ausgeschlafenheit)"
    puts "16 = Neuen Boxer kaufen"
    a = 191
    # w = 19 if rand(20) == 0
    # unless w == 19
      until a < 17 and a > 0 and not a == nil
        a = gets.to_i
      end
    # end
    # a = 7 if w == 19 and not rand(20) == 0
    puts "_______________________________________________________________________________________________"
    puts
    if a == 1
      self.seilspringen
    elsif a == 2
      self.rennen
    elsif a == 3
      self.essen
    elsif a == 4
      self.inkbsackb
    elsif a == 5
      self.ingbsackb
    elsif a == 6
      self.krafttraining
    elsif a == 8
      self.dehnen
    elsif a == 9
      self.yoga
    elsif a == 12
      self.testen
    elsif a == 13
      raise Interrupt
    elsif a == 14
      self.fkessen
    elsif a == 15
      self.schlafen
    elsif a == 16
      puts "Wie soll er heissen?"
      self.boxerkaufen(gets.chomp)
    end
  end
  def herausfordern
    puts "_______________________________________________________________________________________________"
    puts
    super
    self.boxer.each {|boxr| boxr.herausfordern}
  end
  def cherausfordern
    puts "_______________________________________________________________________________________________"
    puts
    super
    self.boxer.each {|boxr| boxr.cherausfordern}
  end
  def boxerkaufen(name=0)
    if @geld < 5000
      puts "Du hast ja gar nicht genug Geld!!" if @kijn == 0
      return
    end
    if rand(5) == 0
      if rand(4) == 0
        puts "Ich hab keinen gefunden, die Kosten will ich natürlich trotzdem bezahlt haben." if @kijn == 0
        kosten = 300 + rand(200)
        @geld -= kosten
        $boxhandel.geld += kosten
        return
      elsif rand(4) == 0
        name[rand(name.length)] = ($vokale + $konsonanten)[rand(($vokale + $konsonanten).length)] if @kijn == 0
        puts "Ich hab zwar einen extrem super Guten gefunden, der #{name} heisst, aber den willst du ja nicht, denn er hat nicht den gewünschten Namen." if @kijn == 0
        @geld -= 300 + rand(200)
        return
      else
        puts "Hab keinen gefunden..." if @kijn == 0
        sleep(1)
        puts "HEY!!! Das ist noch lang kein Grund mich zu hauen!! Willst du Schläge?" if @kijn == 0
        sleep(1)
        self.duell($boxhandel, (1 - @kijn))
        return
      end
    end
    @boxer.push Boxer.new(@player, self, name, @kijn)
    kosten = 3000 + rand(2000)
    @geld -= kosten
    $boxhandel.geld += kosten
    puts "Oh, ja! Ich habe hier zufällig einen ziemlich Guten gefunden, der sogar zufällig \"#{name}\" heisst." if @kijn == 0
  end
  def seilspringen
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um SEILZUSPRINGEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 15
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @gewicht > (@kraft * 10)
      puts "Du bist zu schwer und zu schwach um Seilzuspringen." if @kijn == 0
      return
    end
    @kondition += ((rand(5) + 1)/100.0)
    @kondition += @aufwaermen/50.0
    @aufwaermen += rand(2)
    @gewicht -= (rand(100)/1000.0)
    @hunger += rand(5)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/10.0
    puts "Du probierst verzweifelt, seilzuspringen, schaffst es aber nie mehr als fünf Mal." if @kijn == 0
  end
  def rennen
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu RENNEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 20
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @gewicht > (@kraft * 10)
      puts "Du bist zu schwer und zu schwach um zu rennen." if @kijn == 0
      return
    end
    @kondition += ((rand(3) + 1)/100.0)
    @kondition += @aufwaermen/50.0
    @aufwaermen += rand(5)
    @gewicht -= (rand(200)/1000.0)
    @hunger += rand(7)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/10.0
    puts "Du joggst ein kleines Stückchen, dann fällst du um vor Müdigkeit." if @kijn == 0
  end
  def essen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 5
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @geld < 70
      puts "Du hast ja gar kein Geld! Er darf nicht essen! Rrraus!!" if @kijn == 0
      return
    end
    @gewicht += ((rand(3) + rand(3))/10.0) if @hunger > 10
    @geld -= rand(70) if @hunger > 10
    puts "Das Essen mundet dir sehr." if @kijn == 0 and @hunger > 10
    puts "Du hast aber keinen Hunger!" if @kijn == 0 and @hunger <= 10
    @hunger -= rand(20) if @hunger > 10
  end
  def inkbsackb
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 15
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 10
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 2
      puts "Du bist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if @kijn == 0
      return
    end
    @schnelligkeit += (rand(5)/50.0)
    @schnelligkeit += @aufwaermen/50.0
    @gewicht -= (rand(100)/1000.0)
    @aufwaermen += rand(20)/10.0
    @hunger += rand(3)
    @muedigkeit -= rand(3)
    @dehnbarkeit += rand(5)/10.0
    puts "Bümmele..bübümmele..bübümmele..bübümmele ..bümmelebümmele..bümmele..bübümmele..." if @kijn == 0
  end
  def ingbsackb
    if @kraft > 10 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 13
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 15
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 2
      puts "Du bist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if @kijn == 0
      return
    end
    @staerke += (rand(5)/50.0)
    @staerke += @aufwaermen/50.0
    @gewicht -= (rand(200)/1000.0)
    @aufwaermen += rand(20)/20.0
    @hunger += rand(5)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/10.0
    puts "dong!.....batz!..döff!....doing!..." if @kijn == 0
  end
  def krafttraining
    if @kraft > 15 and @staerke > 5 and @kondition > 5
      super
      return
    end
    if @konzentration < 10
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um KRAFTTRAINING ZU MACHEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 25
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 2
      puts "Du bist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if @kijn == 0
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
    puts "Du machst natürlich leichteres Krafttraining als der Boxer, nach ein paar Liegestützen bist du schon völlig KO." if @kijn == 0
  end
  def dehnen
    if @konzentration < 15
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu DEHNEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 10
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 4
      puts "Du bist zu wenig aufgewärmt dazu." if @kijn == 0
      return
    end
    if @dehnbarkeit < 2
      puts "Deine Dehnbarkeitsstufe ist zu niedrig." if @kijn == 0
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
    puts "Du dehnst." if @kijn == 0
  end
  def yoga
    if @konzentration < 20
      puts "Du bist zu unkonzentriert dazu!" if @kijn == 0
      return
    end  
    if @muedigkeit < 10
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    @konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
    @konzentrationsfaehigkeit += rand(200) / 100.0
    puts "Du machst komische Konzentrationsübungen." if @kijn == 0
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
      puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 5
      puts "Du bist zu müde dazu!" if @kijn == 0
      return
    end
    if @geld < 700
      puts "Du hast ja gar kein Geld! Du darfst nicht essen! Rrraus!!" if @kijn == 0
      return
    end
    @gewicht += ((rand(12) + rand(12))/10.0) if @hunger > 10
    @geld -= rand(700) + 30 if @hunger > 10
    puts "Das Zeug ist dir eigentlich zu fettig, aber es muss sein." if @kijn == 0 and @hunger > 10
    puts "Du hast keinen Hunger!" if @kijn == 0 and @hunger <= 10
    @hunger -= rand(30) if @hunger > 10
  end
end
