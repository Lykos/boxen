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
    puts "#{@name} ist verhungert. Es kommt ein neuer, gleichnamiger Boxertrainer." if @gewicht < 50
    return 1 if @gewicht < 50
    puts "#{@name} ist verhungert. Es kommt ein neuer, gleichnamiger Boxertrainer." if @hunger > 60
    return 1 if @hunger > 60
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

  def ctrunde(i)
    crunde
    if not @name == "Kolibri" or not rand(4) == 0
      $gegner[i] = Player.new(@name) if @trainer.crunde == 1
    end
    if @name == "Elch"
      $gegner[i] = Player.new(@name) if @trainer.crunde == 1
    end
    @boxer.each_with_index do |e, i|
      if i + 1 == @boxer.length
        @boxer.pop if e.crunde == 1
      else
        @boxer[i..-2] = @boxer[i + 1..-1] if e.crunde == 1
      end
    end
  end
end
