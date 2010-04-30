require 'player_manager'

class HumanPlayer < PlayerManager
  def trainer_runde
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
      @player.boxerkaufen(gets.chomp)
    end
  end
  def boxer_runde(boxer)
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
      @player.handel(boxer)
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
      @player.amuletthandel(boxer)
    end
  end
  
  def herausfordern(boxer)
    return if boxer.heraus == 0
    if boxer.human_trainer?
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
      herausfordern(boxer)
    else
      boxer.duell($gegner[tr-1].boxer[bx], 1)
    end
  end

  def start_boxers
    puts "_______________________________________________________________________________________________"
    puts
    puts "Die Runden deiner Boxer:"
  end

  # Prints out general notifications for the player.
  #
  def message(type, *args)
    case type
    when :trainer_no_money
      puts "Du hast ja gar nicht genug Geld!!"
    end
  end

  FORMS = {
    :run => "um zu RENNEN",
    :jump_rope => "um SEILZUSPRINGEN",
    :small_sack => "um einen SACK zu treffen",
    :big_sack => "um einen SACK zu treffen",
    :strength_training => "um KRAFTTRAINING zu MACHEN",
    :stretch => "um zu DEHNEN",
    :wizard => "um DEM ZAUBERER ZUZUHÖREN"
  }

  # Prints out boxer specific notifications for the player.
  #
  def boxer_message(type, name, *args)
    # Tricks for german grammar.
    b = name == "Du" ? "b" : ""
    s = name == "Du" ? "s" : ""
    t = name == "Du" ? "" : "t"
    pronoun = name == "Du" ? "du" : "er"
    case type
    when :no_desire
      puts "#{name} ha#{s}t keine Lust dazu."
    when :no_concentration
      puts "#{name} #{b}ist zu unkonzentriert dazu!"
      print "(JA, du siehst das RICHTIG: #{FORMS[args[0]]} braucht"
      puts "es nicht extrem viel Konzentration)"
    when :too_tired
      puts "#{name} #{b}ist zu müde dazu!"
    when :too_heavy
      puts "#{name} #{b}ist zu schwer und zu schwach um Seilzuspringen."
    when :jump_rope
      puts "#{name} spring#{s}t Seil und ha#{s}t nun mehr Kondition."
    when :run
      print "#{name} renn#{s}t und rennt, bis #{pronoun}"
      puts " nicht mehr kann#{s}#{t}!"
    when :no_eat_money
      puts "#{name} hat ja gar kein Geld! Er darf nicht essen! Rrraus!!"
    when :eats
      puts "Mampf, mjam, schleck, mmh!"
    when :no_hunger
      puts "Bääh, kein Hunger!"
    when :not_warmed_up
      puts "#{name} #{b}ist zu wenig aufgewärmt, um hiermit effektiv trainieren zu können."
    when :small_sack
      puts "Bum..bubum..bubum..bubum ..bumbum..bum..bubum..."
    when :big_sack
      puts "DASCH!!.....BUMM!!..BASCH!....DONNER!!!..WUMM!!."
    when :strenght_training
      puts "#{name} macht Krafttraining. Nachher ist er natürlich hungrig und müde."
    when :no_stretch
      puts "Die Dehnbarkeitsstufe ist zu niedrig."
    when :stretch
      print "#{name} dehn#{s}t. "
      print "#{pronoun.capitalize} ha#{s}t nun alles mögliche besser"
      if name == "Du"
        puts "."
      else
        print ", aber Spass macht ihm das gar nicht"
      end
    when :not_concentrated_enough
      puts "#{name} #{b}ist zu unkonzentriert dazu!"
    when :yoga
      puts "#{name} mach#{s}t komische Konzentrationsübungen."
    when :no_wizard_desire
      puts "#{name} möchte nicht zum Zauberer gehen."
    when :no_wizard_money
      puts "DuUUUU wiLLLst MicH betRRügen? DUhasSSST ja Gar kEin gEld."
      puts "DafÜÜr laSSTet mein Fluch AB jETzt auf dIIER."
      puts "#{name} hat nun sehr grosse Angst und ist psychisch völlig fertig."
    when :wizard
    else
      raise "Unknown message type #{type}."
    end
  end
end
