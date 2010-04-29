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
    @trainer.runde
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

  def ctrunde(i)
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
