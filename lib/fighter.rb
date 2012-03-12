# Represents a boxer (or trainer) in a fight.
#
class Fighter

  # Initialize with a new boxer.
  #
  def initialize(boxer)
    @boxer = boxer
    @name = boxer.name
  end

  attr_reader :name, :boxer
  attr_reader :st, :ak, :init, :agr, :w, :wk, :hk, :kg, :rw, :b, :s, :waffent
  attr_accessor :lp

  # Chose the weapons for one particular fight for humans.
  #
  def waffenwahl
    if @boxer.waffen.length < 3
      @waffent = @boxer.waffen.dup
      return
    elsif @boxer.ki?
      return cwaffenwahl
    end
    @waffent = []
    2.times do
      puts "Welche Waffen willst du mitnehmen?"
      @boxer.waffen.each_with_index do |e, i|
        puts "#{i} = #{e}"
      end
      wahl = @boxer.waffen.length + 1
      until wahl < @boxer.waffen.length
        wahl = gets.to_i
      end
      @waffent.push @boxer.waffen[wahl]
    end
  end

  # Chose the weapons for one particular fight for computers.
  #
  def cwaffenwahl
    kost = 0
    idx = 0
    @wkosten.each_with_index {|e, i| kost, idx = e, i if e > g}
    @waffent = [@boxer.waffen[kost]]
    waff = @waffent[0]
    while @waffent[0] == waff
      waff = @boxer.waffen[rand(@boxer.waffen.length)]
    end
    waffent.push(waff)
  end

  def zusammenhau
    @w -= rand(2)
    @ak -= rand(2)
    @st -= rand(2)
    @agr -= rand(2) unless @agr == 1
    @kg -= rand(2)
  end

  # Adds the boni and mali for standing up.
  #
  def stand_up
    @lp += 2 + rand(3) if @lp < 1
    @lp = 1 if @lp < 1
    @w -= rand(2)
    @ak -= rand(2)
    @st -= rand(2)
    @agr -= rand(2) unless @agr == 1
    @kg -= rand(2)
  end
  
  # Takes care of the effects of losing.
  #
  def lose(over)
    @boxer.motivation -= rand(30 + 10 * over)/10.0
    @boxer.freude -= rand(300 + 100 * over)/10.0
    @boxer.freude = 0 if @boxer.freude < 0
    @boxer.muedigkeit -= 5 * over
  end

  # Takes care of the effects of winning.
  #
  def win
    @boxer.geld += rand(5000)
    @boxer.motivation += rand(30)/10.0
    @boxer.freude += rand(300)/10.0
    @boxer.boss.geld += rand(5000)
  end

  # Takes care of effects after a duel.
  #
  def after_duell
    @boxer.geld += rand(500)
    @boxer.boss.geld += rand(50)
    @boxer.kondition += (rand(10)/20.0)
    @boxer.kondition += @boxer.aufwaermen/10.0
    @boxer.kraft += (rand(10)/10.0)
    @boxer.kraft += @boxer.aufwaermen/10.0
    @boxer.staerke += (rand(10)/10.0)
    @boxer.staerke += @boxer.aufwaermen/10.0
    @boxer.gewicht -= (rand(400)/1000.0)
    @boxer.aufwaermen += rand(40)/20.0
    @boxer.hunger += rand(10)
    @boxer.muedigkeit -= rand(10)
    @boxer.freude -= (rand(70)/10.0)
    @boxer.dehnbarkeit += rand(10)/10.0
  end

  # Prepares the duell values.
  #
  def prepare
    waffenwahl
    @st = 1 + (@boxer.staerke / 10).to_i
    @st += 1 if @waffent.include? "Handschuh der Stärke"
    @st += 2 if @waffent.include? "Donnermeisterhandschuh"
    @agr = 1 + ((@boxer.schnelligkeit+@boxer.aufwaermen)/2).to_i
    @agr *= 2 if @waffent.include? "Meisterhandschuh des Verderbens"
    @agr += 2 if @waffent.include? "Handschuh des Angriffs" or @waffent.include? "Meisterhandschuh des Verderbens"
    @w = 1 + ((@boxer.kondition / 20 + @boxer.aufwaermen) / 2).to_i
    @w += 2 if @boxer.amulette.include? "Amulett der Felsenfestigkeit"
    @w += 1 if @boxer.amulette.include? "Wiederstandsamulett"
    @rw = 6
    4.times do |e|
      @rw -= 1 if @boxer.gewicht - 75 - (25 * e) >= 0
    end
    @rw -= 1 if @boxer.amulette.include? "Amulett der Rüstung"
    @rw -= 2 if @boxer.amulette.include? "stählernes Amulett"
    @kg = @boxer.konzentration / 20
    @kg += 1 if @waffent.include? "Handschuh der Geschicklichkeit"
    @kg += 2 if @waffent.include? "Meisterhandschuh der Geschicklichkeit"
    @init = ((@boxer.muedigkeit/10).to_i)
    @init += gegner.init if @waffent.include? "Blitzhandschuh"
    @lp = 10
    @lp += 2 if @boxer.amulette.include? "Amulett des Lebens"
    @lp += 1 if @boxer.amulette.include? "Amulett der Lebenskraft" 
    @wk = ((@boxer.kondition / 20 + @boxer.kraft / 10) / 2).to_i
    @wk += 1 if @boxer.amulette.include? "Amulett der Standhaftigkeit"  
    @wk += 3 if @boxer.amulette.include? "Amulett der Wiederstandskraft"
    @hk = ((@boxer.staerke / 10 + @boxer.kraft / 10) / 2).to_i
    @hk += 1 if @waffent.include? "Hauhandschuh"     
    @hk += 3 if @waffent.include? "Handschuh des Yetis"
    @ak = ((@boxer.motivation / 10 + @boxer.kraft - @boxer.gewicht / 10 - @boxer.hunger / 10 + @boxer.muedigkeit / 10) / 2).to_i
    @ak += 2 if @boxer.amulette.include? "Amulett der Aufstehkraft" or @boxer.amulette.include? "Amulett der Unerschütterlichkeit"
    @ak *= 2 if @boxer.amulette.include? "Amulett der Unerschütterlichkeit"
    @boxer.heraus = 0 unless @boxer.amulette.include? "Fehdehandschuh"
  end
  
  def duell(gegner, kommentarejn=0)
    prepare
    gegner.prepare
    
    puts "_______________________________________________________________________________________________" if kommentarejn == 1
    puts if kommentarejn == 1
    angr = 0
    sieger = 0
    over = 0
    schlagen(gegner, kommentarejn) if gegner.init < @init
    gegner.schlagen(self, kommentarejn) if gegner.init > @init
    loop do
      angr += 1
      sleep(0.3) if kommentarejn == 1
      puts if kommentarejn == 1
      if angr % @agr == 0 and angr % gegner.agr == 0 and @init > gegner.init
        schlagen(gegner, kommentarejn)
        gegner.schlagen(self, kommentarejn)
      elsif angr % @agr == 0 and angr % gegner.agr == 0
        gegner.schlagen(self, kommentarejn)
        schlagen(gegner, kommentarejn)
      elsif angr % @agr == 0
        gegner.schlagen(self, kommentarejn)
      elsif angr % gegner.agr == 0
        schlagen(gegner, kommentarejn)
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
            print "s" if not @boxer.human_trainer? and kommentarejn == 1
            print "d" if @boxer.human_trainer? and kommentarejn == 1
            puts "ich nun erneut in den Kampf!!" if kommentarejn == 1
            stand_up
            auf = 1
            break
          end
        end
        if auf == 0
          print "#{gegner.name} ha#{gegner.s}t gewonnen!" unless kommentarejn == 0 and gegner.equal?($boxhandel)
          puts $overhau[0 - @lp] unless kommentarejn == 0 and gegner.equal?($boxhandel)
          sieger = gegner
          gegner.win
          lose(over)
          break
        end
      end
      if gegner.lp < 1
        loop1 do |over|
          break if gegner.agr < 2 ** over
          schlagen(gegner, kommentarejn)
        end
        aufg = 0
        10.downto(1) do |countdownzahl|
          puts countdownzahl if kommentarejn == 1
          sleep(1) if kommentarejn == 1
          if rand(50) * (1 + gegner.lp.abs) < (10 - countdownzahl) + gegner.ak
            puts "#{gegner.name} #{gegner.b}ist wieder aufgestanden und stürtz#{gegner.s}t sich nun erneut in den Kampf!!" if kommentarejn == 1
            gegner.stand_up
            aufg = 1
            break
          end
        end
        if aufg == 0
          print "#{@name} ha#{@s}t gewonnen!" unless kommentarejn == 0 and gegner.equal?($boxhandel)
          puts $overhau[0 - gegner.lp] unless kommentarejn == 0 and gegner.equal?($boxhandel)
          sieger = self
          win
          gegner.lose(over)
          break
        end
      end
      if angr > 250
        puts "UNENTSCHIEDEN!!!!!!!!" unless kommentarejn == 0 and gegner.equal?($boxhandel)

        break
      end
    end
    after_duell
    gegner.after_duell
    2.times do |i|
    end
    puts "_______________________________________________________________________________________________" if kommentarejn == 1
    puts if kommentarejn == 1
    return sieger
  end
  def schlagen(gegner, kommentarejn)
    ieser = "ieser"
    ihn = "ihn"
    if @boxer.human_trainer?
      ieser = "u"
      ihn = "dich"
    end
    unless gegner.boxer.human_trainer?
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
          schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      elsif w6 == 2
        if not @waffent.include? "Roboterarm" or alarm == 1
          puts "d#{ieser} weicht jedoch aus." if kommentarejn == 1
          return
        else
          puts "Verfehlt eigentlich, kriegt aber dank seinem Roboterarm wieder eine Gelegenheit zu schlagen."
          @alarm = 1
          schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      elsif w6 == 3 and not @kg > gegner.kg
        if not @waffent.include? "Roboterarm" or alarm == 1
          puts "was d#{ieser} jedoch abwehrt." if kommentarejn == 1
          return
        else
          puts "Verfehlt eigentlich, kriegt aber dank seinem Roboterarm wieder eine Gelegenheit zu schlagen."
          @alarm = 1
          schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      elsif w6 == 4 and gegner.kg > @kg * 2
        if not @waffent.include? "Roboterarm" or alarm == 1
          puts "d#{ieser} entweichst dem Schlag jedoch." if kommentarejn == 1
          return
        else
          puts "Verfehlt eigentlich, kriegt aber dank seinem Roboterarm wieder eine Gelegenheit zu schlagen."
          @alarm = 1
          schlagen(gegner, kommentarejn)
          @alarm = 0
        end
      end
    end
    puts "schafft dies auch," if kommentarejn == 1
    sleep(0.1) if kommentarejn == 1
    unless @waffent.include? "brennender Meisterhandschuh"
      wiederholung = 1
      wiederholung = 2 if gegner.boxer.amulette.include? "Eisenamulett"
      wiederholung.times do
        w6 = 1 + rand(6)
        if w6 == 1
          puts "was #{gegner.name} jedoch aus purem Glück überleb#{gegner.s}t." if kommentarejn == 1
          return
        elsif w6 == 2 and not @st > gegner.w + 1 and not gegner.boxer.human_trainer?
          puts "was #{gegner.name} jedoch aus unbekannten Gründen nichts ausmacht." if kommentarejn == 1
          return
        elsif w6 == 2 and not @st > gegner.w + 1
          puts "was dir jedoch aus unbekannten Gründen nichts ausmacht." if kommentarejn == 1
          return
        elsif w6 == 3 and not @st > gegner.w and not gegner.boxer.human_trainer?
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
      wiederholung = 2 if gegner.boxer.amulette.include? "Gromrilamulett"
      wiederholung.times do
        w6 = 1 + rand(6)
        if w6 == 2 and gegner.rw <= 2
          print "was aber an " if kommentarejn == 1
          print "#{gegner.name}s" if kommentarejn == 1 and not gegner.boxer.human_trainer?
          print "deiner" if kommentarejn == 1 and gegner.boxer.human_trainer?
          puts " überquillender Fettmasse nicht vorbeikommt." if kommentarejn == 1
          return
        elsif w6 == 3 and gegner.rw <= 3
          print "was aber in " if kommentarejn == 1
          print "#{gegner.name}s" if kommentarejn == 1 and not gegner.boxer.human_trainer?
          print "deinem" if kommentarejn == 1 and gegner.boxer.human_trainer?
          puts " schwabbelndem Fett steckenbleibt." if kommentarejn == 1
          return
        elsif w6 == 4 and gegner.rw <= 4
          print "der Schlag wird aber von " if kommentarejn == 1
          print "#{gegner.name}s" if kommentarejn == 1 and not gegner.boxer.human_trainer?
          print "deinem" if kommentarejn == 1 and gegner.boxer.human_trainer?
          puts " Fett derart abgebremst, dass er ihn nicht mehr verletzt." if kommentarejn == 1
          return
        elsif w6 == 5 and gegner.rw <= 5
          print "der Schlag macht " if kommentarejn == 1
          print gegner.name if kommentarejn == 1 and not gegner.boxer.human_trainer?
          print "dir" if kommentarejn == 1 and gegner.boxer.human_trainer?
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
    puts "und er verwundet #{gegner.name}!!! Nun hat dieser nur noch #{gegner.lp} Lebenspunkte!" if kommentarejn == 1 and not gegner.boxer.human_trainer? and not @name.equal?($du.name)
    puts "und er verwundet dich!!! Nun hast du nur noch #{$du.lp} Lebenspunkte!" if kommentarejn == 1 and gegner.boxer.human_trainer?
    puts "und du verwundest #{gegner.name}!!! Nun hat dieser nur noch #{gegner.lp} Lebenspunkte!" if kommentarejn == 1 and @name.equal?($du.name)
    if rand(@hk) > rand(gegner.lp + gegner.wk) or @waffent.include? "Meisterhandschuh des Hasses"
      puts "#{gegner.name} ist nun so zusammengeboxt, dass er nun schlechter kämpft." if kommentarejn == 1
      gegner.zusammenhau
    end
    if rand(3) == 0 or @waffent.include? "Meisterhandschuh der Wut"
      sleep(0.2) if kommentarejn == 1
      puts "Es bietet sich sofort wieder eine Gelegenheit, zuzuschlagen!" if kommentarejn == 1 
      sleep(0.2) if kommentarejn == 1
      schlagen(gegner, kommentarejn)
    end
  end
end
