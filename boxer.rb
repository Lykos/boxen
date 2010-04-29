class Boxer
  def initialize(player, boss, name="juuuuuuuuuuj", kijn=1)
    @player = player
    if kijn == 1
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
    @kijn = kijn
    @heraus = 1
    @kraft = ((@gewicht/10.0)+2)
    @schnelligkeit += 2 if @name == "Bombana"
    @staerke += 10 if @name == "Bahnhof"
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
    @waffent = []
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

  attr_reader :boss
  attr_accessor :name, :kondition, :kraft, :geld, :staerke, :aufwaermen, :motivation
  attr_accessor :konzentration, :schnelligkeit, :freude, :muedigkeit, :hunger, :gewicht
  attr_accessor :dehnbarkeit, :pokal, :kijn, :heraus, :waffen, :waffent, :b, :s
  attr_accessor :st, :ak, :init, :agr, :w, :wk, :hk, :kg, :rw, :lp, :amulette, :kosten

  def human_trainer?
    self.class == Trainer && human?
  end

  def human?
    @player.human?
  end

  def crunde
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
    puts "#{@name}, der Boxer von #{@boss.name}, hört auf." if @motivation < 0
    return 1 if @motivation < 0
    puts "#{@name}, der Boxer von #{@boss.name}, ist verhungert." if @gewicht < 50
    return 1 if @gewicht < 50
    puts "#{@name}, der Boxer von #{@boss.name}, ist verhungert." if @hunger > 60
    return 1 if @hunger > 60
    if @muedigkeit < 1
      self.schlafen
      return 2
    end
    if @hunger > 40
      self.essen if @hunger > 40
      return 2
    end
    if @freude < 1
      self.filmschaun
      return 2
    end
    if @boss.name == "Fuchs" or @boss.name == "Fledermaus" or @boss.name == "Kolibri"
      self.crunde1
    elsif @boss.name == "Biber" or @boss.name == "Rentier"
      self.crunde3
    else
      self.crunde2
    end

  end
  def crunde1
    c = rand(100)
    if @motivation < 2 and @freude < 20
      self.schlafen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if @konzentration < 10
      self.schlafen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if @gewicht < 55 and not @geld < 1000 and not @hunger < 11
      self.fkessen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    elsif @gewicht < 55 and not @geld < 100 and not @hunger < 11
      self.essen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if @hunger > 10 and not @geld < 3000 and @aufwaermen == 0
      self.fkessen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    elsif @hunger > 10 and not @geld < 100 and @aufwaermen == 0
      self.essen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if @freude < 55 and not @geld < 1000 and not @konzentration < 11 and @aufwaermen == 0
      self.filmschaun
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    elsif @freude < 10
      self.schlafen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end  
    if @konzentration < 20
      self.schlafen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if @motivation < 8 and @freude < 20
      self.filmschaun
      c = 3
    end
    if @motivation < 10 and @muedigkeit < 20 and @aufwaermen == 0
      c = 3
    end
    if @konzentration < @konzentrationsfaehigkeit and @aufwaermen == 0 and rand(2) == 0
      self.yoga
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if @muedigkeit < 10
      self.schlafen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if @aufwaermen > 5 and @dehnbarkeit > 2 and @muedigkeit > 10
      self.dehnen
      return if @boss.name == "Fuchs" or @boss.name == "Fledermaus" and not rand(4) == 0
    end
    if c < 5 and @aufwaermen == 0 and @muedigkeit > 5 and @konzentration > 18
      self.zauberer
    elsif c < 15 and @aufwaermen == 0 and @muedigkeit > 5 and @konzentration > 20
      self.yoga
    elsif c < 25 and not @geld < 1000 and not @hunger < 15 and not @gewicht > 150 and @aufwaermen == 0 and @muedigkeit > 5 and @konzentration > 10
      self.fkessen
    elsif c < 30 and not @geld < 100 and not @hunger < 15 and not @gewicht > 155 and @aufwaermen == 0 and @muedigkeit > 5 and @konzentration > 10
      self.essen
    elsif c < 40 and @muedigkeit > 15 and @konzentration > 10
      self.seilspringen
    elsif c < 50 and not @aufwaermen < 3 and @muedigkeit > 25 and @konzentration > 10
      self.krafttraining
    elsif c < 60 and not @aufwaermen < 3 and @muedigkeit > 15 and @konzentration > 13
      self.inkbsackb
    elsif c < 70 and not @aufwaermen < 3 and @muedigkeit > 10 and @konzentration > 15
      self.inkbsackb
    elsif c < 100 and not @aufwaermen > 7 and @muedigkeit > 20 and @konzentration > 10
      self.rennen
    elsif not @muedigkeit > 10 and @konzentration > 15
      self.inkbsackb
    else
      self.schlafen
    end
  end
  def crunde2
    self.seilspringen
    if rand(5) == 0
      self.zauberer
      self.rennen if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.fkessen
      self.fkessen if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.seilspringen 
      self.seilspringen if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.essen
      self.essen if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.filmschaun
      self.filmschaun if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.inkbsackb
      self.inkbsackb if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.ingbsackb
      self.ingbsackb if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.krafttraining
      self.krafttraining if @boss.name == "Igel" or @boss.name == "Hase"
    elsif rand(5) == 0
      self.rennen
      self.rennen if @boss.name == "Igel" or @boss.name == "Hase"
    end
    self.dehnen if @boss.name == "Igel" or @boss.name == "Hase"
  end
  def crunde3
    if @aufwaermen == 0 and @muedigkeit < 40
      if @muedigkeit > 5 and @geld > 100 and @konzentration > 15 and @boss.geld > 100 and @freude < 20
        self.filmschaun
      elsif @hunger > 10 and @geld > 1000 and @konzentration > 5 and @muedigkeit > 5
        self.fkessen
      elsif @hunger > 10 and @konzentration > 5 and @geld > 100 and @muedigkeit > 5
        self.essen
      elsif @muedigkeit > 10 and @konzentration > 20 and @freude > 5 and rand(3) == 0
        self.yoga
      elsif @motivation < 5 and @muedigkeit > 10 and @konzentration > 18 and @freude > 5
        self.zauberer
      elsif @muedigkeit > 10 and @konzentration > 18 and @freude > 5 and rand(3) == 0
        self.zauberer
      elsif @muedigkeit > 10 and @konzentration > 20 and @freude > 5
        self.yoga
      else
        self.schlafen
      end
    elsif @aufwaermen < 2
      if @geld > 100 and @konzentration > 15 and @boss.geld > 100 and @freude < @muedigkeit - 20 and @muedigkeit > 60
        self.filmschaun
      elsif @geld > 100 and @konzentration > 15 and @boss.geld > 100 and @freude < @muedigkeit - 10
        self.filmschaun
      elsif @hunger > 10 and @geld > 1000 and @konzentration > 5
        self.fkessen
      elsif @hunger > 10 and @konzentration > 5
        self.essen
      elsif @konzentration > 20 and @freude > 5 and @konzentration < @muedigkeit - 30 and rand(2) == 0
        self.yoga
      elsif @konzentration > 20 and @freude > 5 and @konzentration < @muedigkeit - 40
        self.yoga
      elsif @konzentration > 10 and @freude > 10
        self.rennen
      else
        self.schlafen
      end
    else
      if @dehnbarkeit > 2 and @konzentration > 15 and @freude > 20 and @aufwaermen > 4 and @muedigkeit > 10
        self.dehnen
      elsif @dehnbarkeit > 2 and @konzentration > 15 and @freude > 20 and @muedigkeit > 20
        self.rennen
      elsif @dehnbarkeit > 2 and @konzentration > 15 and @freude > 20 and @muedigkeit > 15
        self.rennen
      elsif @staerke % 10 < 5 and @muedigkeit > 15 and @konzentration > 10 and @freude > 10
        if rand(4) == 0 or @muedigkeit < 25 and not @konzentration < 13
          self.ingbsackb
        else
          self.krafttraining
        end
      elsif @muedigkeit > 15 and @konzentration > 10 and @freude > 10 and rand(3) == 0
        if rand(4) == 0 or @muedigkeit < 25 and not @konzentration < 13
          self.ingbsackb
        else
          self.krafttraining
        end
      elsif @muedigkeit > 10 and @konzentration > 15 and @freude > 10
        self.inkbsackb
      elsif @muedigkeit > 5 and @geld > 100 and @konzentration > 15 and @boss.geld > 100 and @freude < 20
        self.filmschaun
      elsif @hunger > 10 and @geld > 1000 and @konzentration > 5 and @muedigkeit > 5
        self.fkessen
      elsif @hunger > 10 and @konzentration > 5 and @geld > 100 and @muedigkeit > 5
        self.essen
      else
        self.schlafen
      end
    end
  end
  def runde
    puts "_______________________________________________________________________________________________"
    puts
    puts "#{@name}s Runde:"
    @heraus = 1
    @hunger += (rand(20)/10.0)
    @motivation -= (rand(5)/20.0) if @freude < 20
    @konzentration -= (rand(200)/20.0) if @muedigkeit < 25
    @konzentration -= rand(100)/10.0
    @konzentration += rand(100)/10.0
    @freude -= rand(100)/10.0
    @freude += rand(100)/10.0
    @muedigkeit -= rand(5)
    puts "_______________________________________________________________________________________________"
    puts
    self.testen
    puts "_______________________________________________________________________________________________"
    puts
    puts "#{@name} hört auf." if @motivation < 0
    return 1 if @motivation < 0
    puts "#{@name} ist verhungert." if @hunger > 60
    return 1 if @hunger > 60
    puts "#{@name} ist verhungert." if @gewicht < 50
    return 1 if @gewicht < 50
    if @muedigkeit < 0
      puts "#{@name} ist eingeschlafen."
      self.schlafen
      return 2
    end
    if @hunger > 40
      puts "#{@name} ist so hungrig, dass er einfach essen geht."
      self.essen
      return 2
    end
    if @freude < 1
      puts "#{@name} weint und du musst mit ihm ins Kino gehen um ihn zu trösten."  
      self.filmschaun
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
    elsif a == 10
      self.zauberer
    elsif a == 11
      self.handel
    elsif a == 12
      self.testen
    elsif a == 13
      raise Interrupt
    elsif a == 14
      self.fkessen
    elsif a == 15
      self.schlafen
    elsif a == 16
      self.filmschaun
    elsif a == 17
      self.amuletthandel
    end
  end
  def herausfordern
    return if @heraus == 0
    if human_trainer?
      puts "Gegen den Boxer welches Trainers willst du ein Duell vorschlagen?"
    else
      puts "Gegen den Boxer welches Trainers soll #{@name} kämpfen?"
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
      self.herausfordern
    else
      self.duell($gegner[tr-1].boxer[bx], 1)
    end
  end
  def cherausfordern
    return if @heraus == 0
    pself = (((@schnelligkeit + @aufwaermen) / 2).to_i) * 7 + ((@staerke / 10).to_i) * 4 + (((@kondition + @aufwaermen) / 2).to_i) * 4 + ((@konzentration/20).to_i) * 2 + ((@gewicht - 62)/25).to_i
    pself += 10 unless @boss.name == "Elch" and not @boss.equal?(self)
    $du.boxer.each do |bx|
      next if bx.heraus == 0
      pbx = (((bx.schnelligkeit + bx.aufwaermen) / 2).to_i) * 7 + ((bx.staerke / 10).to_i) * 4 + (((bx.kondition + bx.aufwaermen) / 2).to_i) * 4 + ((bx.konzentration/10).to_i) * 2 + ((bx.gewicht - 62)/25).to_i
      if rand(8) < pself - pbx
        puts "#{@name}, ein Boxer von #{@boss.name}, fordert #{bx.name} zum Duell, willst du annehmen?"
        gets.to_i
        qterw = rand(8)
        if qterw == 0
          puts "Du kannst aber nicht ablehnen, #{bx.name} will unbedingt kämpfen."
        elsif qterw == 1
          puts "Wie ? Du hast #{@name} ganz fest gern? Bist du schwul? Naja, egal, er hat dich jedenfalls gar nicht gern!(!!!!!!!!!!!!!!!)"
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
          puts "#{@boss.name}: Ey, Junge, ich hab dich gefracht, ob du annehmen oder ablehnen willst,"
          puts "da musst du mich noch lang nich haun! Das gibt Haue!!"
          self.boss.duell($du, 1)
        elsif qterw == 7
          puts "#{@name}: ÄÄ WA HAUSCH MISCH? i willte eischlisch dei boxa zusammehaue,"
          puts "aba so hauisch sueas disch!"
          self.duell($du, 1)
        end
        puts "_______________________________________________________________________________________________"
        puts
        self.duell(bx, 1)
        puts "#{bx.name}: So, nun bist du dran!" if qterw == 5
        bx.duell($du, 1) if qterw == 5
        return 2
      end
    end
    $gegner.each do |g|
      next if g.equal?(@boss)
      g.boxer.each do |bx|
        next if bx.heraus == 0
        pbx = (((bx.schnelligkeit + bx.aufwaermen) / 2).to_i) * 7 + ((bx.staerke / 10).to_i) * 4 + (((bx.kondition + bx.aufwaermen) / 2).to_i) * 4 + ((bx.konzentration/10).to_i) * 2 + ((bx.gewicht - 62)/25).to_i
        if rand(8) < pself - pbx
          wahl = 0
          loop do
            print "Willst du das Duell #{@name}s gegen #{bx.name}"
            print ", den Boxer von #{bx.boss.name}, " unless self.equal?(@boss)
            puts "sehen?"
            wahl = gets.chomp
            break if wahl == "j" or wahl == "n"
            puts "j oder n"
          end
          wahl = 1 if wahl == "j"
          self.duell(bx, wahl)
          return 2
          puts
        end
      end
    end
  end
  def handel
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 20
      puts "#{@name} ist zu unkonzentriert, um mit dem Händler zu verhandeln!"
      return
    end
    if @muedigkeit < 10
      puts "#{@name} ist zu müde dazu!"
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
        @waffen.each_with_index do |e, i|
          puts "#{i} = #{e} für #{@wkosten[i]}.00 Fr."
        end
         puts "#{i + 1} = abhauen"
        wahl = angebot.length + 1
        until wahl <= angebot.length
          wahl = gets.to_i
        end
        return if wahl == angebot.length
        @geld += @wkosten[wahl]
        $magisch.push(@waffen.delete_at(wahl))
        $kosten.push(2 * @wkosten.delete_at(wahl))
        @freude -= 10 + rand(20)
        puts "#{@name} freut sich gar nicht, dass er seine Lieblingswaffe hat abgeben müssen!"
        next
      end
      return if wahl == angebot.length + 1
      if @geld < kosten[wahl]
        puts "Tut mir Leid, aber dein Geld reicht nicht."
      else
        @geld -= kosten[wahl]
        @waffen.push(angebot[wahl])
        @wkosten.push(kosten[wahl] / 2)
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
        @freude += rand(20)
        puts "#{@name} freut sich sehr, dass er eine neue Waffe hat!"
      end
    end
  end
  def amuletthandel
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 20
      puts "#{@name} ist zu unkonzentriert, um mit dem Händler zu verhandeln!"
      return
    end
    if @muedigkeit < 10
      puts "#{@name} ist zu müde dazu!"
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
          @waffen.each_with_index do |e, i|
            puts "#{i} = #{e} für #{@wkosten[i]}.00 Fr."
          end
           puts "#{i + 1} = abhauen"
          wahl = angebot.length + 1
          until wahl <= angebot.length
            wahl = gets.to_i
          end
          return if wahl == angebot.length
          @geld += @wkosten[wahl]
          $magisch.push(@waffen.delete_at(wahl))
          $kosten.push(2 * @wkosten.delete_at(wahl))
          @freude -= 10 + rand(20)
          puts "#{@name} freut sich gar nicht, dass er sein Lieblingsamulett abgeben musste!"
          next
        end
      if @geld < kosten[wahl]
        puts "Tut mir Leid, aber dein Geld reicht nicht."
      else
        @geld -= kosten[wahl]
        @amulette.push(angebot[wahl])
        @akosten.push(kosten[wahl])
        $amulette.delete(angebot[wahl])
        $amulettkosten.delete(kosten[wahl])
        angebot.delete_at wahl
        kosten.delete_at wahl
        @freude += rand(20)
        puts "#{@name} freut sich sehr, dass er eine neues Amulett hat!"
      end
    end
  end
  def seilspringen
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if @kijn == 0
      return
    end
    if @konzentration < 10
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um SEILZUSPRINGEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 15
      puts "#{@name} #{@b}ist zu müde dazu!" if @kijn == 0
      return
    end
    if @gewicht > (@kraft * 10)
      puts "#{@name} #{@b}ist zu schwer und zu schwach um Seilzuspringen." if @kijn == 0
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
    puts "#{@name} spring#{@s}t Seil und ha#{@s}t nun mehr Kondition." if @kijn == 0
  end
  def rennen
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if @kijn == 0
      return
    end
    if @konzentration < 10
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu RENNEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 20
      puts "#{@name} #{@b}ist zu müde dazu!" if @kijn == 0
      return
    end
    if @gewicht > (@kraft * 10)
      puts "#{@name} #{@b}ist zu schwer und zu schwach um zu rennen." if @kijn == 0
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
    print "#{@name} renn#{@s}t und rennt, bis " if @kijn == 0
    if @boss == self
      print "du" if @kijn == 0
    else
      print "er" if @kijn == 0
    end
    puts" nicht mehr kann#{@s}#{@t}!" if @kijn == 0
  end
  def essen
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 10
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 5
      puts "#{@name} ist zu müde dazu!" if @kijn == 0
      return
    end
    if @geld < 70
      puts "#{@name} hat ja gar kein Geld! Er darf nicht essen! Rrraus!!" if @kijn == 0
      return
    end
    @gewicht += ((rand(3) + rand(3))/10.0) if @hunger > 10
    @geld -= rand(70) if @hunger > 10
    puts "Mampf, mjam, schleck, mmh!" if @kijn == 0 and @hunger > 10
    puts "Bääh, kein Hunger!" if @kijn == 0 and @hunger <= 10
    @hunger -= rand(20) if @hunger > 10
  end
  def inkbsackb
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if @kijn == 0
      return
    end
    if @konzentration < 15
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 10
      puts "#{@name} #{@b}ist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 2
      puts "#{@name} #{@b}ist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if @kijn == 0
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
    puts "Bum..bubum..bubum..bubum ..bumbum..bum..bubum..." if @kijn == 0
  end
  def ingbsackb
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if @kijn == 0
      return
    end
    if @konzentration < 13
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um einen SACK zu treffen braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 15
      puts "#{@name} #{@b}ist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 2
      puts "#{@name} #{@b}ist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if @kijn == 0
      return
    end
    @staerke += (rand(5)/50.0)
    @staerke += @aufwaermen/50.0
    @gewicht -= (rand(200)/1000.0)
    @aufwaermen += rand(20)/20.0
    @hunger += rand(5)
    @muedigkeit -= rand(5)
    @dehnbarkeit += rand(10)/50.0
    puts "DASCH!!.....BUMM!!..BASCH!....DONNER!!!..WUMM!!." if @kijn == 0
  end
  def krafttraining
    if @freude < 10
      puts "#{@name} ha#{@s}t keine Lust dazu." if @kijn == 0
      return
    end
    if @konzentration < 10
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um KRAFTTRAINING ZU MACHEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 25
      puts "#{@name} #{@b}ist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 2
      puts "#{@name} #{@b}ist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können." if @kijn == 0
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
    puts "#{@name} macht Krafttraining. Nachher ist er natürlich hungrig und müde." if @kijn == 0
  end
  def dehnen
    if @freude < 20
      puts "#{@name} ha#{@s}t keine Lust dazu." if @kijn == 0
      return
    end
    if @konzentration < 15
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu DEHNEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 10
      puts "#{@name} #{@b}ist zu müde dazu!" if @kijn == 0
      return
    end
    if @aufwaermen < 4
      puts "#{@name} #{@b}ist zu wenig aufgewärmt dazu." if @kijn == 0
      return
    end
    if @dehnbarkeit < 2
      puts "Die Dehnbarkeitsstufe ist zu niedrig." if @kijn == 0
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
    print "#{@name} dehn#{@s}t. " if @kijn == 0
    print "Du" if self.equal?(@boss) and @kijn == 0
    print "Er" if not self.equal?(@boss) and @kijn == 0
    print " ha#{@s}t nun alles mögliche besser" if @kijn == 0
    print ", aber Spass macht ihm das gar nicht" if @kijn == 0 and not @boss.equal?(self)
    puts "." if @kijn == 0
  end
  def yoga
    if @freude < 5
      puts "#{@name} ha#{@s}t keine Lust dazu." if @kijn == 0
      return
    end
    if @konzentration < 20
      puts "#{@name} #{@b}ist zu unkonzentriert dazu!" if @kijn == 0
      return
    end  
    if @muedigkeit < 10
      puts "#{@name} #{@b}ist zu müde dazu!" if @kijn == 0
      return
    end
    @konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
    @konzentrationsfaehigkeit += rand(200) / 100.0
    puts "#{@name} mach#{@s}t komische Konzentrationsübungen." if @kijn == 0
  end
  def zauberer
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @freude < 5
      puts "#{@name} möchte nicht zum Zauberer gehen." if @kijn == 0
      return
    end
    if @konzentration < 18
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um DEM ZAUBERER ZUZUHÖREN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @geld < 70
      puts "DuUUUU wiLLLst MicH betRRügen? DUhasSSST ja Gar kEin gEld." if @kijn == 0
      puts "DafÜÜr laSSTet mein Fluch AB jETzt auf dIIER." if @kijn == 0
      puts "#{@name} hat nun sehr grosse Angst und ist psychisch völlig fertig." if @kijn == 0
      @motivation = 0
      @freude = 0
    end
    if @muedigkeit < 10
      puts "#{@name} ist zu müde dazu!" if @kijn == 0
      return
    end
    @motivation += (rand(21)/10.0) if @motivation < 100
    @geld -= rand(70)
    puts "SooOo meIN SoHn, dUUUUU bist aLsOO traurig? Dannn zuber ich dich gutt. NuN biSt dUUU dea BAÄSTE!" if @kijn == 0
  end
  def filmschaun
    @dehnbarkeit = 0
    @aufwaermen = 0
    if @konzentration < 15
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um EINEN FILM ZU SCHAUEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 5
      puts "#{@name} ist zu müde dazu!" if @kijn == 0
      return
    end
    if @boss.geld < 70
      puts "Du hast ja gar kein Geld! Du darfst nicht ins Kino! Rrraus!!" if @kijn == 0
      return
    end
    if @geld < 70
      puts "#{@name} hat ja gar kein Geld! Er darf nicht ins Kino! Rrraus!!" if @kijn == 0
      return
    end
    @geld -= rand(70)
    @boss.geld -= rand(70)
    @freude += rand(21)
    puts "Der Film gefällt dem Boxer sehr. Dir ist er eigentlich zu doof. Das hat natürlich auch seinen Preis: Der Eintritt ist teuer." if @kijn == 0
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
    puts "Chrr Zzz!" if @kijn == 0
    puts "#{@name} ha#{@s}t nun geschlafen, #{@b}ist aber auch hungriger geworden." if @kijn == 0
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
      puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
      return
    end
    if @muedigkeit < 5
      puts "#{@name} ist zu müde dazu!" if @kijn == 0
      return
    end
    if @geld < 700
      puts "#{@name} hat ja gar kein Geld! Er darf nicht essen! Rrraus!!" if @kijn == 0
      return
    end
    @gewicht += ((rand(12) + rand(12))/10.0) if @hunger > 10
    @geld -= rand(700) + 30 if @hunger > 10
    puts "mmh! leckaschmecka!! mehr!" if @kijn == 0 and @hunger > 10
    puts "OOH! WAAS??!! DAS SOLL DER PREIS SEIN!!?? NIE WIEDER!!" if @kijn == 0 and @hunger > 10
    puts "Bääh, kein Hunger!" if @kijn == 0 and @hunger <= 10
    @hunger -= rand(30) if @hunger > 10
  end
  def waffenwahl
    if @waffen.length < 3
      @waffent = @waffen.dup
      return
    elsif @kijn == 1
      return cwaffenwahl
    end
    @waffent = []
    2.times do
      puts "Welche Waffen willst du mitnehmen?"
      @waffen.each_with_index do |e, i|
        puts "#{i} = #{e}"
      end
      wahl = @waffen.length + 1
      until wahl < @waffen.length
        wahl = gets.to_i
      end
      @waffent.push @waffen[wahl]
    end
  end
  def cwaffenwahl
    kost = 0
    idx = 0
    @wkosten.each_with_index {|e, i| kost, idx = e, i if e > g}
    @waffent = [@waffen[kost]]
    waff = @waffent[0]
    while @waffent[0] == waff
      waff = @waffen[rand(@waffen.length)]
    end
    waffent.push(waff)
  end
  def schlagen(gegner, kommentarejn)
    ieser = "ieser"
    ihn = "ihn"
    if @name.equal?($du.name)
      ieser = "u"
      ihn = "dich"
    end
    unless gegner.human_trainer?
      puts "#{@name} probier#{@s}t #{gegner.name} zu schlagen," if kommentarejn == 1
    else
      puts "#{@name} probiert dich zu schlagen," if kommentarejn == 1
    end
    w6 = 1 + rand(6)
    w6 += 1 if @waffent.include? "zitternder Handschuh"
    sleep(0.1) if kommentarejn == 1
    unless @waffent.include? "automatischer Meisterhandschuh"
      if w6 == 1
        if not @waffent.include? "Roboterarm" or alarm == 1
          puts "triff#{@s}t #{ihn} aber nicht." if kommentarejn == 1
          return
        else
          puts "Verfehlt eigentlich, kriegt aber dank seinem Roboterarm wieder eine Gelegenheit zu schlagen."
          @alarm = 1
          self.schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      elsif w6 == 2
        if not @waffent.include? "Roboterarm" or alarm == 1
          puts "d#{ieser} weicht jedoch aus." if kommentarejn == 1
          return
        else
          puts "Verfehlt eigentlich, kriegt aber dank seinem Roboterarm wieder eine Gelegenheit zu schlagen."
          @alarm = 1
          self.schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      elsif w6 == 3 and not @kg > gegner.kg
        if not @waffent.include? "Roboterarm" or alarm == 1
          puts "was d#{ieser} jedoch abwehrt." if kommentarejn == 1
          return
        else
          puts "Verfehlt eigentlich, kriegt aber dank seinem Roboterarm wieder eine Gelegenheit zu schlagen."
          @alarm = 1
          self.schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      elsif w6 == 4 and gegner.kg > @kg * 2
        if not @waffent.include? "Roboterarm" or alarm == 1
          puts "d#{ieser} entweichst dem Schlag jedoch." if kommentarejn == 1
          return
        else
          puts "Verfehlt eigentlich, kriegt aber dank seinem Roboterarm wieder eine Gelegenheit zu schlagen."
          @alarm = 1
          self.schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      end
    end
    puts "schafft dies auch," if kommentarejn == 1
    sleep(0.1) if kommentarejn == 1
    unless @waffent.include? "brennender Meisterhandschuh"
      wiederholung = 1
      wiederholung = 2 if gegner.amulette.include? "Eisenamulett"
      wiederholung.times do
        w6 = 1 + rand(6)
        if w6 == 1
          puts "was #{gegner.name} jedoch aus purem Glück überleb#{gegner.s}t." if kommentarejn == 1
          return
        elsif w6 == 2 and not @st > gegner.w + 1 and not gegner.human_trainer?
          puts "was #{gegner.name} jedoch aus unbekannten Gründen nichts ausmacht." if kommentarejn == 1
          return
        elsif w6 == 2 and not @st > gegner.w + 1
          puts "was dir jedoch aus unbekannten Gründen nichts ausmacht." if kommentarejn == 1
          return
        elsif w6 == 3 and not @st > gegner.w and not gegner.human_trainer?
          puts "was #{gegner.name} jedoch nicht verwundet." if kommentarejn == 1
          return
        elsif w6 == 3 and not @st > gegner.w
          puts "was dich jedoch nicht verwundet." if kommentarejn == 1
          return
        elsif w6 == 4 and gegner.w > @st  
          puts "was #{gegner.name} mit einem Lächeln quittier#{gegner.s}t." if kommentarejn == 1
          return
        elsif w6 == 5 and gegner.w > @st + 1
          puts "#{gegner.name} jedoch lach#{gegner.s}t nur über diesen schwachen Schlag." if kommentarejn == 1
          return
        elsif w6 == 6 and gegner.w > @st + 3
          puts "was #{gegner.name} jedoch nicht bemerk#{gegner.s}t." if kommentarejn == 1
          return
        end
      end
    end
    unless @waffent.include? "rüstungsbrechender Meisterhandschuh"
      wiederholung = 1
      wiederholung = 2 if gegner.amulette.include? "Gromrilamulett"
      wiederholung.times do
        w6 = 1 + rand(6)
        if w6 == 2 and gegner.rw <= 2
          print "was aber an " if kommentarejn == 1
          print "#{gegner.name}s" if kommentarejn == 1 and not gegner.human_trainer?
          print "deiner" if kommentarejn == 1 and gegner.human_trainer?
          puts " überquillender Fettmasse nicht vorbeikommt." if kommentarejn == 1
          return
        elsif w6 == 3 and gegner.rw <= 3
          print "was aber in " if kommentarejn == 1
          print "#{gegner.name}s" if kommentarejn == 1 and not gegner.human_trainer?
          print "deinem" if kommentarejn == 1 and gegner.human_trainer?
          puts " schwabbelndem Fett steckenbleibt." if kommentarejn == 1
          return
        elsif w6 == 4 and gegner.rw <= 4
          print "der Schlag wird aber von " if kommentarejn == 1
          print "#{gegner.name}s" if kommentarejn == 1 and not gegner.human_trainer?
          print "deinem" if kommentarejn == 1 and gegner.human_trainer?
          puts " Fett derart abgebremst, dass er ihn nicht mehr verletzt." if kommentarejn == 1
          return
        elsif w6 == 5 and gegner.rw <= 5
          print "der Schlag macht " if kommentarejn == 1
          print gegner.name if kommentarejn == 1 and not gegner.human_trainer?
          print "dir" if kommentarejn == 1 and gegner.human_trainer?
          puts " aber nicht aus." if kommentarejn == 1
          return
        elsif w6 == 6 and gegner.rw <= 6
          puts "#{gegner.name} schwank#{gegner.s}t darauf zwar, verliert aber keinen Lebenspunkt." if kommentarejn == 1
          return
        end
      end
    end
    gegner.lp -= 1
    gegner.lp -= 1 if @waffent.include? "Meisterhandschuh des Todes"
    puts "und er verwundet #{gegner.name}!!! Nun hat dieser nur noch #{gegner.lp} Lebenspunkte!" if kommentarejn == 1 and not gegner.human_trainer? and not @name.equal?($du.name)
    puts "und er verwundet dich!!! Nun hast du nur noch #{$du.lp} Lebenspunkte!" if kommentarejn == 1 and gegner.human_trainer?
    puts "und du verwundest #{gegner.name}!!! Nun hat dieser nur noch #{gegner.lp} Lebenspunkte!" if kommentarejn == 1 and @name.equal?($du.name)
    if rand(@hk) > rand(gegner.lp + gegner.wk) or @waffent.include? "Meisterhandschuh des Hasses"
      puts "#{gegner.name} ist nun so zusammengeboxt, dass er nun schlechter kämpft." if kommentarejn == 1
      gegner.w -= rand(2)
      gegner.ak -= rand(2)
      gegner.st -= rand(2)
      gegner.agr -= rand(2) unless gegner.agr == 1
      gegner.kg -= rand(2)
    end
    if rand(3) == 0 or @waffent.include? "Meisterhandschuh der Wut"
      sleep(0.2) if kommentarejn == 1
      puts "Es bietet sich sofort wieder eine Gelegenheit, zuzuschlagen!" if kommentarejn == 1 
      sleep(0.2) if kommentarejn == 1
      schlagen(gegner, kommentarejn)
    end
  end
  def duell(gegner, kommentarejn=0)
    self.waffenwahl
    gegner.waffenwahl
    puts "_______________________________________________________________________________________________" if kommentarejn == 1
    puts if kommentarejn == 1
    @st = 1 + (@staerke / 10).to_i
    @st += 1 if @waffent.include? "Handschuh der Stärke"
    @st += 2 if @waffent.include? "Donnermeisterhandschuh"
    gegner.st = 1 + (gegner.staerke / 10).to_i
    gegner.st += 1 if gegner.waffent.include? "Handschuh der Stärke"
    gegner.st += 2 if gegner.waffent.include? "Donnermeisterhandschuh"
    @agr = 1 + ((@schnelligkeit+@aufwaermen)/2).to_i
    @agr *= 2 if @waffent.include? "Meisterhandschuh des Verderbens"                     
    @agr += 2 if @waffent.include? "Handschuh des Angriffs" or @waffent.include? "Meisterhandschuh des Verderbens"
    gegner.agr = 1 + ((gegner.schnelligkeit+gegner.aufwaermen)/2).to_i
    gegner.agr *= 2 if gegner.waffent.include? "Meisterhandschuh des Verderbens"
    gegner.agr += 2 if gegner.waffent.include? "Handschuh des Angriffs" or gegner.waffent.include? "Meisterhandschuh des Verderbens"
    @w = 1 + ((@kondition / 20 + @aufwaermen) / 2).to_i
    @w += 2 if @amulette.include? "Amulett der Felsenfestigkeit"
    @w += 1 if @amulette.include? "Wiederstandsamulett"
    gegner.w = 1 + ((gegner.kondition / 20 + gegner.aufwaermen) / 2).to_i
    gegner.w += 2 if gegner.amulette.include? "Amulett der Felsenfestigkeit"
    gegner.w += 1 if gegner.amulette.include? "Wiederstandsamulett"
    @rw = 6
    4.times do |e|
      @rw -= 1 if @gewicht - 75 - (25 * e) >= 0
    end
    @rw -= 1 if @amulette.include? "Amulett der Rüstung"
    @rw -= 2 if @amulette.include? "stählernes Amulett"
    gegner.rw = 6
    4.times do |e|
      gegner.rw -= 1 if gegner.gewicht - 75 - (25 * e) >= 0
    end
    gegner.rw -= 1 if gegner.amulette.include? "Amulett der Rüstung"
    gegner.rw -= 2 if gegner.amulette.include? "stählerner Amulett"
    @kg = @konzentration / 20
    @kg += 1 if @waffent.include? "Handschuh der Geschicklichkeit"
    @kg += 2 if @waffent.include? "Meisterhandschuh der Geschicklichkeit"
    gegner.kg = gegner.konzentration / 20
    gegner.kg += 1 if gegner.waffent.include? "Handschuh der Geschicklichkeit"
    gegner.kg += 2 if gegner.waffent.include? "Meisterhandschuh der Geschicklichkeit"
    @init = ((@muedigkeit/10).to_i)
    gegner.init = ((gegner.muedigkeit/10).to_i)
    gegner.init += 1 if @init == gegner.init
    @init += gegner.init if gegner.waffent.include? "Blitzhandschuh"
    gegner.init += @init if gegner.waffent.include? "Blitzhandschuh" 
    @lp = 10
    @lp += 2 if @amulette.include? "Amulett des Lebens"
    @lp += 1 if @amulette.include? "Amulett der Lebenskraft" 
    gegner.lp = 10
    gegner.lp += 2 if gegner.amulette.include? "Amulett des Lebens"
    gegner.lp += 1 if gegner.amulette.include? "Amulett der Lebenskraft" 
    @wk = ((@kondition / 20 + @kraft / 10) / 2).to_i
    @wk += 1 if @amulette.include? "Amulett der Standhaftigkeit"  
    @wk += 3 if @amulette.include? "Amulett der Wiederstandskraft"
    gegner.wk = ((gegner.kondition / 20 + gegner.kraft / 10) / 2).to_i
    gegner.wk += 1 if gegner.amulette.include? "Amulett der Standhaftigkeit"
    gegner.wk += 3 if gegner.amulette.include? "Amulett der Wiederstandskraft"
    @hk = ((@staerke / 10 + @kraft / 10) / 2).to_i
    @hk += 1 if @waffent.include? "Hauhandschuh"     
    @hk += 3 if @waffent.include? "Handschuh des Yetis"
    gegner.hk = ((gegner.staerke / 10 + gegner.kraft / 10) / 2).to_i
    gegner.hk += 1 if gegner.waffent.include? "Hauhandschuh"     
    gegner.hk += 3 if gegner.waffent.include? "Handschuh des Yetis"
    @ak = ((@motivation / 10 + @kraft - gewicht / 10 - @hunger / 10 + @muedigkeit / 10) / 2).to_i
    @ak += 2 if @amulette.include? "Amulett der Aufstehkraft" or @amulette.include? "Amulett der Unerschütterlichkeit"
    @ak *= 2 if @amulette.include? "Amulett der Unerschütterlichkeit"
    gegner.ak = ((gegner.motivation / 10 + gegner.kraft - gegner.gewicht / 10 - gegner.hunger / 10 + gegner.muedigkeit / 10) / 2).to_i
    gegner.ak += 2 if gegner.amulette.include? "Amulett der Aufstehkraft" or gegner.amulette.include? "Amulette"
    gegner.ak *= 2 if gegner.amulette.include? "Amulett der Unerschütterlichkeit"
    angr = 0
    gegner.heraus = 0 unless gegner.amulette == "Fehdehandschuh"
    @heraus = 0 unless @amulette.include? "Fehdehandschuh"
    sieger = 0
    over = 0
    self.schlagen(gegner, kommentarejn) if gegner.init < @init
    gegner.schlagen(self, kommentarejn) if gegner.init > @init
    loop do
      angr += 1
      sleep(0.3) if kommentarejn == 1
      puts if kommentarejn == 1
      if angr % @agr == 0 and angr % gegner.agr == 0 and @init > gegner.init
        self.schlagen(gegner, kommentarejn)
        gegner.schlagen(self, kommentarejn)
      elsif angr % @agr == 0 and angr % gegner.agr == 0
        gegner.schlagen(self, kommentarejn)
        self.schlagen(gegner, kommentarejn)
      elsif angr % @agr == 0
        gegner.schlagen(self, kommentarejn)
      elsif angr % gegner.agr == 0
        self.schlagen(gegner, kommentarejn)
      end
      if @lp < 1
        loop1 do |over|
          break if @agr < 2 ** over
          gegner.schlagen(self, kommentarejn)
        end
        auf = 0
        10.downto(1) do |countdownzahl|
          puts countdownzahl if kommentarejn == 1
          sleep(1) if kommentarejn == 1
          if rand(50) * (1 + lp.abs) < (10 - countdownzahl) + @ak
            puts "#{@name} #{@b}ist wieder aufgestanden und stürtz#{@s}t " if kommentarejn == 1
            print "s" if not self.human_trainer? and kommentarejn == 1
            print "d" if self.human_trainer? and kommentarejn == 1
            puts "ich nun erneut in den Kampf!!" if kommentarejn == 1
            @lp += 2 + rand(3) if @lp < 1
            @lp = 1 if @lp < 1
            @w -= rand(2)
            @ak -= rand(2)
            @st -= rand(2)
            @agr -= rand(2) unless @agr == 1
            @kg -= rand(2)
            auf = 1
            break
          end
        end
        if auf == 0
          print "#{gegner.name} ha#{gegner.s}t gewonnen!" unless kommentarejn == 0 and gegner.equal?($boxhandel)
          puts $overhau[0 - @lp] unless kommentarejn == 0 and gegner.equal?($boxhandel)
          sieger = gegner
          gegner.geld += rand(5000)
          gegner.motivation += rand(30 + 10 * over)/10.0
          gegner.freude += rand(300 + 100 * over)/10.0
          gegner.boss.geld += rand(5000)
          @motivation -= rand(30 + 10 * over)/10.0
          @freude -= rand(300 + 100 * over)/10.0
          @freude = 0 if @freude < 0
          @muedigkeit -= 5 * over
          break
        end
      end
      if gegner.lp < 1
        loop1 do |over|
          break if gegner.agr < 2 ** over
          self.schlagen(gegner, kommentarejn)
        end
        aufg = 0
        10.downto(1) do |countdownzahl|
          puts countdownzahl if kommentarejn == 1
          sleep(1) if kommentarejn == 1
          if rand(50) * (1 + gegner.lp.abs) < (10 - countdownzahl) + gegner.ak
            puts "#{gegner.name} #{gegner.b}ist wieder aufgestanden und stürtz#{gegner.s}t sich nun erneut in den Kampf!!" if kommentarejn == 1
            gegner.lp += 2 + rand(3) if gegner.lp < 1
            gegner.lp = 1 if gegner.lp < 1
            gegner.w -= rand(2)
            gegner.ak -= rand(2)
            gegner.st -= rand(2)
            gegner.agr -= rand(2) unless gegner.agr == 1
            gegner.kg -= rand(2)
            aufg = 1
            break
          end
        end
        if aufg == 0
          print "#{@name} ha#{@s}t gewonnen!" unless kommentarejn == 0 and gegner.equal?($boxhandel)
          puts $overhau[0 - gegner.lp] unless kommentarejn == 0 and gegner.equal?($boxhandel)
          sieger = self
          @geld += rand(5000)
          @motivation += rand(30)/10.0
          @freude += rand(300)/10.0
          @boss.geld += rand(5000)
          gegner.motivation -= rand(30)/10.0
          gegner.freude -= rand(300)/10.0
          gegner.freude = 0 if gegner.freude < 0
          gegner.muedigkeit -= 5 * over
          break
        end
      end
      if angr > 250
        puts "UNENTSCHIEDEN!!!!!!!!" unless kommentarejn == 0 and gegner.equal?($boxhandel)

        break
      end
    end
      2.times do |i|
      geg = self if i == 0
      geg = gegner if i == 1
      geg.geld += rand(500)
      geg.boss.geld += rand(50)
      geg.kondition += (rand(10)/20.0)
      geg.kondition += @aufwaermen/10.0
      geg.kraft += (rand(10)/10.0)
      geg.kraft += @aufwaermen/10.0
      geg.staerke += (rand(10)/10.0)
      geg.staerke += @aufwaermen/10.0
      geg.gewicht -= (rand(400)/1000.0)
      geg.aufwaermen += rand(40)/20.0
      geg.hunger += rand(10)
      geg.muedigkeit -= rand(10)
      geg.freude -= (rand(70)/10.0)
      geg.dehnbarkeit += rand(10)/10.0
    end
    puts "_______________________________________________________________________________________________" if kommentarejn == 1
    puts if kommentarejn == 1
    return sieger
  end
end
