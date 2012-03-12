require 'forwardable'

# Represents one particular player and handles the game logic about this player.
#
class Player
  def initialize(name, manager, human=false, *args)
    @name = name
    @manager = manager
    @human = human
    @trainer = Trainer.new(self, name, *args)
    @boxer = [Boxer.new(self, @trainer, *args)]
    @manager.player = self
  end

  extend Forwardable

  def_delegators :@manager, :boxer_message, :message
  attr_reader :boxer, :trainer, :human, :name, :manager

  def human?
    @human
  end

  def trunde
    trainer_runde
    @manager.start_boxers
    @boxer.each_with_index do |e, i|
      if i + 1 == boxer.length
        @boxer.pop if boxer_runde(e) == 1
      else
        @boxer[i..-2] = @boxer[i + 1..-1] if boxer_runde(e) == 1
      end
    end
  end

  def ctrunde(i)
    if not @name == "Kolibri" or not rand(4) == 0
      $gegner[i] = Player.new(@name, @manager) if trainer_crunde == 1
    end
    if @name == "Elch"
      $gegner[i] = Player.new(@name, @manager) if trainer_crunde == 1
    end
    @boxer.each_with_index do |e, i|
      if i + 1 == @boxer.length
        @boxer.pop if boxer_crunde(e) == 1
      else
        @boxer[i..-2] = @boxer[i + 1..-1] if boxer_crunde(e) == 1
      end
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
    @manager.boxer_runde(boxer)
  end

  def boxer_runde(boxer)
    puts "_______________________________________________________________________________________________"
    puts
    puts "#{boxer.name}s Runde:"
    puts "_______________________________________________________________________________________________"
    puts
    boxer.testen
    puts "_______________________________________________________________________________________________"
    puts
    result = boxer.runde
    if result == :gives_up
      puts "#{boxer.name} hört auf."
      return 1
    end
    if result == :starved
      puts "#{boxer.name} ist verhungert."
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
    @manager.boxer_runde(boxer)
  end
  def herausfordern
    puts "_______________________________________________________________________________________________"
    puts
    @manager.herausfordern(@trainer)
    @boxer.each {|boxer| @manager.herausfordern(boxer)}
  end
  def boxerkaufen(name=0)
    if @trainer.geld < 5000
      @boxer_manager.message(:trainer_no_money)
      return
    end
    if rand(5) == 0
      if rand(4) == 0
        puts "Ich hab keinen gefunden, die Kosten will ich natürlich trotzdem bezahlt haben." if human?
        kosten = 300 + rand(200)
        @trainer.geld -= kosten
        $boxhandel.trainer.geld += kosten
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
    $boxhandel.trainer.geld += kosten
    puts "Oh, ja! Ich habe hier zufällig einen ziemlich Guten gefunden, der sogar zufällig \"#{name}\" heisst." if human?
  end

  def trainer_crunde
    return 1 if @trainer.runde == :starved
    @manager.trainer_runde
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
    @manager.trainer_runde
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
