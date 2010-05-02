require 'player_manager'

class AIPlayer < PlayerManager
  def trainer_runde
    c = rand(100)
    @trainer.schlafen if @trainer.konzentration < 20
    @trainer.schlafen if @trainer.muedigkeit < 10
    if @trainer.geld > 6500
      @player.boxerkaufen
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
      @player.boxerkaufen
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

  def herausfordern(boxer)
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
          boxer.boss.duell($du, 1)
        elsif qterw == 7
          puts "#{boxer.name}: ÄÄ WA HAUSCH MISCH? i willte eischlisch dei boxa zusammehaue,"
          puts "aba so hauisch sueas disch!"
          boxer.duell($du, 1)
        end
        puts "_______________________________________________________________________________________________"
        puts
        boxer.duell(bx, 1)
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
          boxer.duell(bx, wahl)
          return 2
          puts
        end
      end
    end
  end
end
