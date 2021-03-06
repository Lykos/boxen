#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'yaml'
require 'boxer'
require 'trainer'
require 'player'
require 'player_manager'
require 'human_player'
require 'ai_player1'
require 'ai_player2'
require 'ai_player3'
require 'ai_player_kolibri'
require 'ai_player_elch'

# Still a hack to keep the old things compatible to the new ones.
data = YAML.load(File.read(File.join('..', 'config.yml')))
names = data[:magic].collect { |b| b[:name] }
costs = data[:magic].collect { |b| b[:cost] }
$magisch = names + names.collect { |n| n.dup }
$kosten = costs * 2
$amulette = data[:amulets].collect { |b| b[:name] }
$amulettkosten = data[:amulets].collect { |b| b[:cost] }
$vokale = []
data[:vocals].each { |k, v| v.times { $vokale.push k.dup } }
$vokalfolger = data[:vocal_next]
$konsonanten = []
data[:consonants].each { |k, v| v.times { $konsonanten.push k.dup } }
$konsonantenfolger = data[:consonant_next]

z1 = data[:z1]
z = data[:z]
7.times {|i2| z.push(z[i2 + 2] + "ZEHN")}
8.times do |i1|
  z.push(z1[i1])
  9.times {|i2| z.push(z[i2] + "UND" + z1[i1])}
end
$overhau = z
$overhau.each_index do |i|
  $overhau[i] += "FACH-"
end
$overhau[0], $overhau[1] = "", "DOPPEL-"
$overhau.each_index do |i|
  $overhau[i] = "!! MIT #{$overhau[i]}OVERHAU !!!!!!"
end
$overhau.unshift("")

def loop1
  a = 0
  loop do 
    yield a
    a += 1
  end
end


$boxhandel = Player.new("Boxerverk�ufer", AIPlayer2.new)
$gegner = [
    Player.new("Kolibri", AIPlayerKolibri.new),
    Player.new("Rentier", AIPlayer3.new),
    Player.new("Biber", AIPlayer3.new),
    Player.new("Fledermaus", AIPlayer1.new),
    Player.new("Fuchs", AIPlayer1.new),
    Player.new("Hase", AIPlayer3.new),
    Player.new("Igel", AIPlayer3.new),
    Player.new("Wolf", AIPlayer3.new),
    Player.new("Elch", AIPlayerElch.new)]
$gegner.each {|g| print g.boxer[0].name, " ist der Boxer vom ", g.name, "\n"}
puts "Du sollst auch einen Boxer trainieren. Wie soll er heissen?"
$du = Player.new("Du", HumanPlayer.new, true, gets.chomp)
runde = 0
duellrunde = 11 + rand(10)
begin
  loop do
    runde += 1
    [
      Thread.new {$du.trunde},
      Thread.new {
        $gegner.each_with_index do |g,i|
          g.ctrunde(i)
        end
      }
    ].each { |thread| thread.join }
    if duellrunde == runde
      puts "_______________________________________________________________________________________________"
      puts
      puts "DUELLRUNDE:"
      $gegner.each_with_index do |g,i|
        g.herausfordern
      end
      $boxhandel.trainer_crunde
      $du.herausfordern
      duellrunde += 1 + rand(20)
    end
  end
rescue Interrupt
end
puts "_______________________________________________________________________________________________"
puts
puts "ABSCHLUSSVERGLEICH:"
puts "_______________________________________________________________________________________________"
puts
puts "           DU:"
puts "          _____"
puts
$du.trainer.testen
puts "_______________________________________________________________________________________________"
puts
puts "                   ....und deine Boxer:"  
$du.boxer.each do |b|
  puts "_______________________________________________________________________________________________"
  puts
  puts
  puts "           #{b.name}:"
  print "          ___"; b.name.length.times {print "_"}; puts
  puts
  b.testen
end
$gegner.each do |g|
  puts "_______________________________________________________________________________________________"
  puts
  puts
  puts "           #{g.name}:"
  print "          ___"; g.name.length.times {print "_"}; puts
  puts
  g.trainer.testen
  puts "_______________________________________________________________________________________________"
  puts
  puts "                   ....und seine Boxer:"  
  g.boxer.each do |b|
    puts "_______________________________________________________________________________________________"
    puts
    puts
    puts "           #{b.name}:"
    print "          ___"; b.name.length.times {print "_"}; puts
    puts
    b.testen
  end
end
