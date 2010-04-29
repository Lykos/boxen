require 'trainer'

class Player
  def initialize(name, human=false, *args)
    @name = name
    @trainer = Trainer.new(self, name, *args)
    @boxer = @trainer.boxer
    @human = human
  end

  attr_reader :boxer, :trainer, :human

  def human?
    @human
  end

  def method_missing(id, *args)
    trainer.send(id, *args)
  end

  def trunde
    trainer_runde
    puts "_______________________________________________________________________________________________"
    puts
    puts "Die Runden deiner Boxer:"
    @boxer.each_with_index do |e, i|
      if i + 1 == boxer.length
        @boxer.pop if boxer_runde(e) == 1
      else
        @boxer[i..-2] = @boxer[i + 1..-1] if boxer_runde(e) == 1
      end
    end
  end

  def ctrunde(i)
    trainer_crunde
    if not @name == "Kolibri" or not rand(4) == 0
      $gegner[i] = Player.new(@name) if trainer_crunde == 1
    end
    if @name == "Elch"
      $gegner[i] = Player.new(@name) if trainer_crunde == 1
    end
    @boxer.each_with_index do |e, i|
      if i + 1 == @boxer.length
        @boxer.pop if boxer_crunde(e) == 1
      else
        @boxer[i..-2] = @boxer[i + 1..-1] if boxer_crunde(e) == 1
      end
    end
  end

  def trainer_crunde
    return 1 if @trainer.runde == :starved
    c = rand(100)
    @trainer.schlafen if @trainer.konzentration < 20
    @trainer.schlafen if @trainer.muedigkeit < 10
    if @trainer.geld > 6500
      boxerkaufen
      return 2
    end
    if @trainer.gewicht < 55 and not @trainer.geld < 1000 and not @trainer.hunger < 11
      @trainer.fkessen
    elsif @trainer.gewicht < 55 and not @trainer.geld < 100 and not @trainer.hunger < 11
      @trainer.essen
    end
    @trainer.yoga if @trainer.konzentration < @trainer.konzentrationsfaehigkeit and @trainer.aufwaermen == 0 and rand(3) == 0
    if @trainer.hunger > 10 and not @trainer.geld < 5000 and @trainer.aufwaermen == 0
      @trainer.fkessen
    elsif @trainer.hunger > 10 and not @trainer.geld < 100 and @trainer.aufwaermen == 0
      @trainer.essen
    end
    @trainer.dehnen if @trainer.aufwaermen > 5 and @trainer.dehnbarkeit > 2 and @trainer.muedigkeit > 10
    if c < 5 and @trainer.geld > 5000
      boxerkaufen
    elsif c < 15 and @trainer.aufwaermen == 0
      @trainer.yoga
    elsif c < 25 and not @trainer.geld < 1000 and not @trainer.hunger < 15 and not @trainer.gewicht > 150 and @trainer.aufwaermen == 0
      @trainer.fkessen
    elsif c < 30 and not @trainer.geld < 100 and not @trainer.hunger < 15 and not @trainer.gewicht > 155 and @trainer.aufwaermen == 0
      @trainer.essen
    elsif c < 40
      @trainer.seilspringen
    elsif c < 50 and not @trainer.aufwaermen < 3 and @trainer.muedigkeit > 25
      @trainer.krafttraining
    elsif c < 60 and not @trainer.aufwaermen < 3 and @trainer.muedigkeit > 15
      @trainer.inkbsackb
    elsif c < 70 and not @trainer.aufwaermen < 3 and @trainer.muedigkeit > 10
      @trainer.inkbsackb
    elsif c < 100 and not @trainer.aufwaermen > 7 and @trainer.muedigkeit > 20
      @trainer.rennen
    elsif not @trainer.muedigkeit > 10
      @trainer.inkbsackb
    else
      @trainer.schlafen
    end
  end

  def trainer_runde
    result = @trainer.runde
    if result == :starved
      puts "Du bist verhungert."
      raise Interrupt
    end
    if result == :sleeps
      puts "Du bist eingeschlafen."
      @trainer.schlafen
      return 2
    end
    puts "_______________________________________________________________________________________________"
    puts
    puts "Deine Runde:"
    puts "_______________________________________________________________________________________________"
    puts
    @trainer.testen
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
    puts "12 = Testen (genau wissen, wie gut du bist)"
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
      @trainer.seilspringen
    elsif a == 2
      @trainer.rennen
    elsif a == 3
      @trainer.essen
    elsif a == 4
      @trainer.inkbsackb
    elsif a == 5
      @trainer.ingbsackb
    elsif a == 6
      @trainer.krafttraining
    elsif a == 8
      @trainer.dehnen
    elsif a == 9
      @trainer.yoga
    elsif a == 12
      @trainer.testen
    elsif a == 13
      raise Interrupt
    elsif a == 14
      @trainer.fkessen
    elsif a == 15
      @trainer.schlafen
    elsif a == 16
      puts "Wie soll er heissen?"
      boxerkaufen(gets.chomp)
    end
  end

  def boxer_crunde(boxer)
    result = boxer.runde
    if result == :gives_up
      puts "#{boxer.name}, der Boxer von #{@name}, hört auf."
      return 1
    end
    if result == :starved
      puts "#{boxer.name}, der Boxer von #{@name}, ist verhungert."
      return 1
    end
    return 2 if [:eats, :sleeps, :cinema].include?(result)
 
    if @name == "Fuchs" or @name == "Fledermaus" or @name == "Kolibri"
      boxer_crunde1(boxer)
    elsif @name == "Biber" or @name == "Rentier"
      boxer_crunde3(boxer)
    else
      boxer_crunde2(boxer)
    end
  end

  def boxer_crunde1(boxer)
    c = rand(100)
    if boxer.motivation < 2 and boxer.freude < 20
      boxer.schlafen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    end
    if boxer.konzentration < 10
      boxer.schlafen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    end
    if boxer.gewicht < 55 and not boxer.geld < 1000 and not boxer.hunger < 11
      boxer.fkessen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    elsif boxer.gewicht < 55 and not boxer.geld < 100 and not boxer.hunger < 11
      boxer.essen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    end
    if boxer.hunger > 10 and not boxer.geld < 3000 and boxer.aufwaermen == 0
      boxer.fkessen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    elsif boxer.hunger > 10 and not boxer.geld < 100 and boxer.aufwaermen == 0
      boxer.essen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    end
    if boxer.freude < 55 and not boxer.geld < 1000 and not boxer.konzentration < 11 and boxer.aufwaermen == 0
      boxer.filmschaun
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    elsif boxer.freude < 10
      boxer.schlafen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    end  
    if boxer.konzentration < 20
      boxer.schlafen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
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
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    end
    if boxer.muedigkeit < 10
      boxer.schlafen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
    end
    if boxer.aufwaermen > 5 and boxer.dehnbarkeit > 2 and boxer.muedigkeit > 10
      boxer.dehnen
      return if @name == "Fuchs" or @name == "Fledermaus" and not rand(4) == 0
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
  def boxer_crunde2(boxer)
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
  def boxer_crunde3(boxer)
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
  def boxer_runde(boxer)
    result = runde
    puts "_______________________________________________________________________________________________"
    puts
    puts "#{boxer.name}s Runde:"
    puts "_______________________________________________________________________________________________"
    puts
    boxer.testen
    puts "_______________________________________________________________________________________________"
    puts
    result = runde
    if result == :gives_up
      puts "#{boxer.name} hört auf."
      return 1
    end
    if result == :starved
      puts "#{boxer.name} hört auf."
      return 1
    end
    if result == :sleeps
      puts "#{boxer.name} ist eingeschlafen."
      return 2
    end
    if result == :eats
      puts "#{boxer.name} ist so hungrig, dass er einfach essen geht."
      return 2
    end
    if result == :cinema
      puts "#{boxer.name} weint und du musst mit ihm ins Kino gehen um ihn zu trösten."  
      return 2
    end
    puts "1 = Seilspringen (Kondition)"
    puts "2 = Rennen (Kondition/Aufwärmen)"
    puts "3 = Essen (Gewicht)"
    puts "4 = In den kleinen Boxsack boxen (Schnelligkeit)"
    puts "5 = In den grossen Boxsack boxen (Stärke)"
    puts "6 = Krafttraining (Kraft, Stärke, Kondition)"
    puts "8 = Dehnen (Alles mögliche)"
    puts "9 = Yoga (Konzentration)"
    puts "10 = Zum Zauberer gehen (Motivation)"
    puts "11 = Zum Händler gehen (mehr magische Gegenstände)"
    puts "12 = Testen (genau wissen, wie gut er ist)"
    puts "13 = Aufhören (Nicht mehr zusehen müssen, wie der Compi viel besser ist als du(!!!!))"
    puts "14 = Fettige Sachen und Kaviar Essen (Gewicht)"
    puts "15 = schlafen (Ausgeschlafenheit)"
    puts "16 = Zusammen ins Kino gehen (Freude)"
    puts "17 = Zum Schamanen gehen (mehr Amulette)"
    a = 191
      until a < 18 and a > 0 and not a == nil
        a = gets.to_i
      end
    puts "_______________________________________________________________________________________________"
    puts
    if a == 1
      boxer.seilspringen
    elsif a == 2
      boxer.rennen
    elsif a == 3
      boxer.essen
    elsif a == 4
      boxer.inkbsackb
    elsif a == 5
      boxer.ingbsackb
    elsif a == 6
      boxer.krafttraining
    elsif a == 8
      boxer.dehnen
    elsif a == 9
      boxer.yoga
    elsif a == 10
      boxer.zauberer
    elsif a == 11
      handel(boxer)
    elsif a == 12
      boxer.testen
    elsif a == 13
      raise Interrupt
    elsif a == 14
      boxer.fkessen
    elsif a == 15
      boxer.schlafen
    elsif a == 16
      boxer.filmschaun
    elsif a == 17
      amuletthandel(boxer)
    end
  end
  def herausfordern
    puts "_______________________________________________________________________________________________"
    puts
    boxer_herausfordern(@trainer)
    @boxer.each {|boxer| boxer_herausfordern(boxer)}
  end
  def cherausfordern
    puts "_______________________________________________________________________________________________"
    puts
    boxer_cherausfordern(@trainer)
    @boxer.each {|boxer| boxer_cherausfordern(boxer)}
  end
  def boxerkaufen(name=0)
    if @trainer.geld < 5000
      puts "Du hast ja gar nicht genug Geld!!" if human?
      return
    end
    if rand(5) == 0
      if rand(4) == 0
        puts "Ich hab keinen gefunden, die Kosten will ich natürlich trotzdem bezahlt haben." if human?
        kosten = 300 + rand(200)
        @trainer.geld -= kosten
        $boxhandel.geld += kosten
        return
      elsif rand(4) == 0
        name[rand(name.length)] = ($vokale + $konsonanten)[rand(($vokale + $konsonanten).length)] if human?
        puts "Ich hab zwar einen extrem super Guten gefunden, der #{name} heisst, aber den willst du ja nicht, denn er hat nicht den gewünschten Namen." if human?
        @trainer.geld -= 300 + rand(200)
        return
      else
        puts "Hab keinen gefunden..." if human?
        sleep(1)
        puts "HEY!!! Das ist noch lang kein Grund mich zu hauen!! Willst du Schläge?" if human?
        sleep(1)
        @trainer.duell($boxhandel.trainer, human? ? 1 : 0)
        return
      end
    end
    @boxer.push Boxer.new(self, @trainer, name)
    kosten = 3000 + rand(2000)
    @trainer.geld -= kosten
    $boxhandel.geld += kosten
    puts "Oh, ja! Ich habe hier zufällig einen ziemlich Guten gefunden, der sogar zufällig \"#{name}\" heisst." if human?
  end
  def boxer_herausfordern(boxer)
    return if boxer.heraus == 0
    if human_trainer?
      puts "Gegen den Boxer welches Trainers willst du ein Duell vorschlagen?"
    else
      puts "Gegen den Boxer welches Trainers soll #{boxer.name} kämpfen?"
    end
    puts "0 = WILL GAR KEIN DULL"
    $gegner.each_with_index do |g,i|
      puts "#{i + 1} = #{g.name}s"
    end
    puts "#{$gegner.length + 1} = gegen einen deiner Boxer"
    tr = $gegner.length + 2
    tr = gets.to_i until tr < $gegner.length + 1
    return 2 if tr == 0
    puts "Gegen welchen Boxer von #{$gegner[tr-1].name} willst du ein Duell vorschlagen?"
    $gegner[tr-1].boxer.each_with_index do |g,i|
      puts "#{i} = #{g.name}"
    end
    bx = $gegner[tr-1].boxer.length
    bx = gets.to_i until bx < $gegner[tr-1].boxer.length
    if $gegner[tr-1].boxer[bx].heraus == 0
      puts "Tut mir Leid, der hat heute schon gekämpft, also nochmal:"
      herausfordern
    else
      duell($gegner[tr-1].boxer[bx], 1)
    end
  end
  def boxer_cherausfordern(boxer)
    return if boxer.heraus == 0
    pself = (((boxer.schnelligkeit + boxer.aufwaermen) / 2).to_i) * 7 + ((boxer.staerke / 10).to_i) * 4 + (((boxer.kondition + boxer.aufwaermen) / 2).to_i) * 4 + ((boxer.konzentration/20).to_i) * 2 + ((boxer.gewicht - 62)/25).to_i
    pself += 10 unless @name == "Elch" and not boxer.boss.equal?(self)
    $du.boxer.each do |bx|
      next if bx.heraus == 0
      pbx = (((bx.schnelligkeit + bx.aufwaermen) / 2).to_i) * 7 + ((bx.staerke / 10).to_i) * 4 + (((bx.kondition + bx.aufwaermen) / 2).to_i) * 4 + ((bx.konzentration/10).to_i) * 2 + ((bx.gewicht - 62)/25).to_i
      if rand(8) < pself - pbx
        puts "#{boxer.name}, ein Boxer von #{@name}, fordert #{bx.name} zum Duell, willst du annehmen?"
        gets.to_i
        qterw = rand(8)
        if qterw == 0
          puts "Du kannst aber nicht ablehnen, #{bx.name} will unbedingt kämpfen."
        elsif qterw == 1
          puts "Wie ? Du hast #{boxer.name} ganz fest gern? Bist du schwul? Naja, egal, er hat dich jedenfalls gar nicht gern!(!!!!!!!!!!!!!!!)"
        elsif qterw == 2
          puts "Du nimmst mit Vergnügen an und lachst ihn aus? War das nicht etwas voreilig? bist du dir deiner Sache so sicher? Naja, es wird sich zeigen, was dabei herauskommt..."
        elsif qterw == 3
          puts "Dir ist es egal, du interessierst dich sowieso nicht so sehr dafür und wir sollen dich entlich in Ruhe lassen? Na, und so was nennt sich einen Profi-Boxertrainer. Jaja, die ham wir gern..."
        elsif qterw == 4
          puts "Du willst das Duell annehmen? HAHA! Das war die falsche Entscheidung, das wird dir noch Leid tun, HAHAHA!!!"
        elsif qterw == 5
          puts "#{bx.name}: WAS?!?! DU LEHNST AB?!?!"
          puts "DU BIST ZWAR MEIN TRAINER ABER SO ETWAS TUST DU MIR NICHT AN!!!"
          puts "DAFÜR VERHAUE ICH DICH NACHHER!!!"
        elsif qterw == 6
          puts "#{@name}: Ey, Junge, ich hab dich gefracht, ob du annehmen oder ablehnen willst,"
          puts "da musst du mich noch lang nich haun! Das gibt Haue!!"
          boss.duell($du, 1)
        elsif qterw == 7
          puts "#{boxer.name}: ÄÄ WA HAUSCH MISCH? i willte eischlisch dei boxa zusammehaue,"
          puts "aba so hauisch sueas disch!"
          duell($du, 1)
        end
        puts "_______________________________________________________________________________________________"
        puts
        duell(bx, 1)
        puts "#{bx.name}: So, nun bist du dran!" if qterw == 5
        bx.duell($du, 1) if qterw == 5
        return 2
      end
    end
    $gegner.each do |g|
      next if g.equal?(boxer.boss)
      g.boxer.each do |bx|
        next if bx.heraus == 0
        pbx = (((bx.schnelligkeit + bx.aufwaermen) / 2).to_i) * 7 + ((bx.staerke / 10).to_i) * 4 + (((bx.kondition + bx.aufwaermen) / 2).to_i) * 4 + ((bx.konzentration/10).to_i) * 2 + ((bx.gewicht - 62)/25).to_i
        if rand(8) < pself - pbx
          wahl = 0
          loop do
            print "Willst du das Duell #{boxer.name}s gegen #{bx.name}"
            print ", den Boxer von #{bx.boss.name}, " unless equal?(boxer.boss)
            puts "sehen?"
            wahl = gets.chomp
            break if wahl == "j" or wahl == "n"
            puts "j oder n"
          end
          wahl = 1 if wahl == "j"
          duell(bx, wahl)
          return 2
          puts
        end
      end
    end
  end
  def handel(boxer)
    boxer.dehnbarkeit = 0
    boxer.aufwaermen = 0
    if boxer.konzentration < 20
      puts "#{boxer.name} ist zu unkonzentriert, um mit dem Händler zu verhandeln!"
      return
    end
    if boxer.muedigkeit < 10
      puts "#{boxer.name} ist zu müde dazu!"
      return
    end
    puts "Welche meiner magischen Waffen willst du kaufen?"
    angebot = []
    kosten = []
    $magisch.each_with_index do |e, i|
      if rand(($kosten[i] / 1000).to_i) == 0
        angebot.push(e)
        kosten.push($kosten[i])
      end
    end
    loop do
      puts
      i = 0
      angebot.each_with_index do |e, i|
        puts "#{i} = #{e} für #{kosten[i]}.00 Fr."
      end
      puts "#{i + 1} = eigene Waffen verkaufen"
      puts "#{i + 2} = abhauen"
      wahl = angebot.length + 2
      until wahl < angebot.length + 2
        wahl = gets.to_i
      end
      if wahl == angebot.length
        puts "Welche deiner Waffen willst du mir verkaufen?"
        i = 0
        boxer.waffen.each_with_index do |e, i|
          puts "#{i} = #{e} für #{boxer.wkosten[i]}.00 Fr."
        end
         puts "#{i + 1} = abhauen"
        wahl = angebot.length + 1
        until wahl <= angebot.length
          wahl = gets.to_i
        end
        return if wahl == angebot.length
        boxer.geld += boxer.wkosten[wahl]
        $magisch.push(boxer.waffen.delete_at(wahl))
        $kosten.push(2 * boxer.wkosten.delete_at(wahl))
        boxer.freude -= 10 + rand(20)
        puts "#{boxer.name} freut sich gar nicht, dass er seine Lieblingswaffe hat abgeben müssen!"
        next
      end
      return if wahl == angebot.length + 1
      if boxer.geld < kosten[wahl]
        puts "Tut mir Leid, aber dein Geld reicht nicht."
      else
        boxer.geld -= kosten[wahl]
        boxer.waffen.push(angebot[wahl])
        boxer.wkosten.push(kosten[wahl] / 2)
        waffi = 0
        kosti = 0
        $magisch.each_index do |i|
          waffi = i if $magisch[i] == angebot[wahl]
          kosti = i if $kosten[i] == kosten[wahl]
        end
        $magisch.delete_at(waffi)
        $kosten.delete_at(kosti)
        angebot.delete_at wahl
        kosten.delete_at wahl
        boxer.freude += rand(20)
        puts "#{boxer.name} freut sich sehr, dass er eine neue Waffe hat!"
      end
    end
  end
  def amuletthandel(boxer)
    boxer.dehnbarkeit = 0
    boxer.aufwaermen = 0
    if boxer.konzentration < 20
      puts "#{boxer.name} ist zu unkonzentriert, um mit dem Händler zu verhandeln!"
      return
    end
    if boxer.muedigkeit < 10
      puts "#{boxer.name} ist zu müde dazu!"
      return
    end
    puts "Welche meiner magischen Amulette willst du kaufen?"
    angebot = []
    kosten = []
    $amulette.each_with_index do |e, i|
      if rand(($amulettkosten[i] / 1000).to_i) == 0
        angebot.push(e)
        kosten.push($amulettkosten[i])
      end
    end
    loop do
      i = 0
      angebot.each_with_index do |e, i|
        puts "#{i} = #{e} für #{kosten[i]}.00 Fr."
      end
      puts "#{i + 1} = eigene Amulette verkaufen"
      puts "#{i + 2} = abhauen"
      wahl = angebot.length + 2
      until wahl < angebot.length + 2
        wahl = gets.to_i
      end
      return if wahl == angebot.length + 1
        if wahl == angebot.length
          puts "Welche deiner Waffen willst du mir verkaufen?"
          i = 0
          boxer.waffen.each_with_index do |e, i|
            puts "#{i} = #{e} für #{boxer.wkosten[i]}.00 Fr."
          end
           puts "#{i + 1} = abhauen"
          wahl = angebot.length + 1
          until wahl <= angebot.length
            wahl = gets.to_i
          end
          return if wahl == angebot.length
          boxer.geld += boxer.wkosten[wahl]
          $magisch.push(boxer.waffen.delete_at(wahl))
          $kosten.push(2 * boxer.wkosten.delete_at(wahl))
          boxer.freude -= 10 + rand(20)
          puts "#{boxer.name} freut sich gar nicht, dass er sein Lieblingsamulett abgeben musste!"
          next
        end
      if boxer.geld < kosten[wahl]
        puts "Tut mir Leid, aber dein Geld reicht nicht."
      else
        boxer.geld -= kosten[wahl]
        boxer.amulette.push(angebot[wahl])
        boxer.akosten.push(kosten[wahl])
        $amulette.delete(angebot[wahl])
        $amulettkosten.delete(kosten[wahl])
        angebot.delete_at wahl
        kosten.delete_at wahl
        boxer.freude += rand(20)
        puts "#{boxer.name} freut sich sehr, dass er eine neues Amulett hat!"
      end
    end
  end
end
