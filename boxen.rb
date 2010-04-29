#!/usr/bin/env ruby

require 'yaml'

# Still a hack to keep the old things compatible to the new ones.
data = YAML::load(File.read('config.yml'))
names = data[:magic].collect { |b| b[:name] }
costs = data[:magic].collect { |b| b[:cost] }
$magisch = names + names.collect { |n| n.dup }
$kosten = costs + costs.collect { |n| n.dup }
$amulette = ["Eisenamulett", "Gromrilamulett", "Amulett der Felsenfestigkeit", "Wiederstandsamulett",
"Amulett der R�stung", "st�hlernes Amulett", "Amulett der Standhaftigkeit",
"Amulett der Wiederstandskraft", "Amulett des Lebens", "Amulett der Lebenskraft",
"Amulett der Aufstehkraft", "Amulett der Unersch�tterlichkeit", "Fehdehandschuh"]
$amulettkosten = [18000, 16000, 20000, 18000, 14000, 16000, 18000, 14000, 16000, 14000, 16000, 16000, 24000, 14000]
$vokale = %w(a a a e e e e e i i o o o u u � � �) # 18 Zeichen
$vokalfolger = {"a" => "u", "e" => "i", "i" => "e", "o" => "", "u" => "", "�" => "u", "�" => "", "�" => ""}
$konsonanten = %w(b b b b c c c d d d d f f f f g g h h h j j k k k k k l l l l l m m m m n n n n p p p qu r r r s s s s s t t t t t v w x y z sch sch sch ch ch) # 61 Zeichen
$konsonantenfolger = {
"b" => %w(b d d g h j l l l m m n n r r s s t t y),
"c" => %w(k),
"d" => %w(b d g g h j l l m n r r s t y),
"f" => %w(b b d d f f g j k k l m n p r s t x y z sch),
"g" => %w(g j l l m r y sch),
"h" => $konsonanten,
"j" => [""],
"k" => %w(b f j l l l m m n n p r r t t y z sch),
"l" => %w(b b d d f f g g h j k k l l l m m n n p p s s t t z sch),
"m" => %w(b d f g j k k n p p s t t y z sch),
"n" => %w(b b d f g g h j k k n r s t t y z sch),
"p" => %w(d f f g h j k k l m n p p s t t y sch),
"qu" => %w(ar),
"r" => %w(b d d f g j k l l m m n p r s t t y z sch sch),
"s" => %w(b d g j k l m n p p s s t y ch),
"t" => %w(f g h j k k l m n p r s t t y z z sch),
"v" => %w(er),
"w" => %w(y),
"x" => %w(y),
"y" => [""],
"z" => %w(g g j k k l m n p t y),
"sch" => $konsonanten,
"ch" => $konsonanten
}

z1 = ["ZWANZIG", "DREISSIG", "VIERZIG", "F�NGZIG", "SECHZIG", "SIEBZIG", "ACHTZIG", "NEUNZIG"]
z = ["EIN", "ZWEI", "DREI", "VIER", "F�NF", "SECHS", "SIEBEN", "ACHT", "NEUN", "ZEHN", "ELF", "ZW�LF"]
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

class Boxer
	def initialize(boss, name="juuuuuuuuuuj", kijn=1)
		if kijn == 1
			if rand(3) == 0
				name = $vokale[rand(18)]
				buchstabe = $konsonanten[rand(61)]
				name += buchstabe
				name += $konsonantenfolger[buchstabe][rand($konsonantenfolger[buchstabe].length)] if rand(3) == 0
			else
				name = $konsonanten[rand(61)]
			end
			3.times do
				buchstabe = $vokale[rand($vokale.length)]
				name += buchstabe
				name += $vokalfolger[buchstabe] if rand(3) == 0
				buchstabe = $konsonanten[rand($konsonanten.length)]
				name += buchstabe
				name += $konsonantenfolger[buchstabe][rand($konsonantenfolger[buchstabe].length)] if rand(3) == 0
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
	attr_accessor "name"
	attr_accessor "kondition"
	attr_accessor "kraft"
	attr_accessor "geld"
	attr_accessor "staerke"
	attr_accessor "aufwaermen"
	attr_accessor "motivation"
	attr_accessor "konzentration"
	attr_accessor "schnelligkeit"
	attr_accessor "freude"
	attr_accessor "muedigkeit"
	attr_accessor "hunger"
	attr_accessor "gewicht"
	attr_accessor "dehnbarkeit"
	attr_accessor "pokal"
	attr_accessor "kijn"
	attr_accessor "heraus"
	attr_accessor "boss"
	attr_accessor "waffen"
	attr_accessor "waffent"
	attr_accessor "b"
	attr_accessor "s"
	attr_accessor "st"
	attr_accessor "ak"
	attr_accessor "init"
	attr_accessor "agr"
	attr_accessor "w"
	attr_accessor "wk"
	attr_accessor "hk"
	attr_accessor "kg"
	attr_accessor "rw"
	attr_accessor "lp"
	attr_accessor "amulette"
	attr_accessor "kosten"
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
		puts "#{@name}, der Boxer von #{@boss.name}, h�rt auf." if @motivation < 0
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
		puts "#{@name} h�rt auf." if @motivation < 0
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
			puts "#{@name} weint und du musst mit ihm ins Kino gehen um ihn zu tr�sten."	
			self.filmschaun
			return 2
		end
		puts "1 = Seilspringen (Kondition)"
		puts "2 = Rennen (Kondition/Aufw�rmen)"
		puts "3 = Essen (Gewicht)"
		puts "4 = In den kleinen Boxsack boxen (Schnelligkeit)"
		puts "5 = In den grossen Boxsack boxen (St�rke)"
		puts "6 = Krafttraining (Kraft, St�rke, Kondition)"
		puts "8 = Dehnen (Alles m�gliche)"
		puts "9 = Yoga (Konzentration)"
		puts "10 = Zum Zauberer gehen (Motivation)"
		puts "11 = Zum H�ndler gehen (mehr magische Gegenst�nde)"
		puts "12 = Testen (genau wissen, wie gut er ist)"
		puts "13 = Aufh�ren (Nicht mehr zusehen m�ssen, wie der Compi viel besser ist als du(!!!!))"
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
		if self.object_id == @boss.object_id
			puts "Gegen den Boxer welches Trainers willst du ein Duell vorschlagen?"
		else
			puts "Gegen den Boxer welches Trainers soll #{@name} k�mpfen?"
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
			puts "Tut mir Leid, der hat heute schon gek�mpft, also nochmal:"
			self.herausfordern
		else
			self.duell($gegner[tr-1].boxer[bx], 1)
		end
	end
	def cherausfordern
		return if @heraus == 0
		pself = (((@schnelligkeit + @aufwaermen) / 2).to_i) * 7 + ((@staerke / 10).to_i) * 4 + (((@kondition + @aufwaermen) / 2).to_i) * 4 + ((@konzentration/20).to_i) * 2 + ((@gewicht - 62)/25).to_i
		pself += 10 unless @boss.name == "Elch" and not @boss.object_id == self.object_id
		$du.boxer.each do |bx|
			next if bx.heraus == 0
			pbx = (((bx.schnelligkeit + bx.aufwaermen) / 2).to_i) * 7 + ((bx.staerke / 10).to_i) * 4 + (((bx.kondition + bx.aufwaermen) / 2).to_i) * 4 + ((bx.konzentration/10).to_i) * 2 + ((bx.gewicht - 62)/25).to_i
			if rand(8) < pself - pbx
				puts "#{@name}, ein Boxer von #{@boss.name}, fordert #{bx.name} zum Duell, willst du annehmen?"
				gets.to_i
				qterw = rand(8)
				if qterw == 0
					puts "Du kannst aber nicht ablehnen, #{bx.name} will unbedingt k�mpfen."
				elsif qterw == 1
					puts "Wie ? Du hast #{@name} ganz fest gern? Bist du schwul? Naja, egal, er hat dich jedenfalls gar nicht gern!(!!!!!!!!!!!!!!!)"
				elsif qterw == 2
					puts "Du nimmst mit Vergn�gen an und lachst ihn aus? War das nicht etwas voreilig? bist du dir deiner Sache so sicher? Naja, es wird sich zeigen, was dabei herauskommt..."
				elsif qterw == 3
					puts "Dir ist es egal, du interessierst dich sowieso nicht so sehr daf�r und wir sollen dich entlich in Ruhe lassen? Na, und so was nennt sich einen Profi-Boxertrainer. Jaja, die ham wir gern..."
				elsif qterw == 4
					puts "Du willst das Duell annehmen? HAHA! Das war die falsche Entscheidung, das wird dir noch Leid tun, HAHAHA!!!"
				elsif qterw == 5
					puts "#{bx.name}: WAS?!?! DU LEHNST AB?!?!"
					puts "DU BIST ZWAR MEIN TRAINER ABER SO ETWAS TUST DU MIR NICHT AN!!!"
					puts "DAF�R VERHAUE ICH DICH NACHHER!!!"
				elsif qterw == 6
					puts "#{@boss.name}: Ey, Junge, ich hab dich gefracht, ob du annehmen oder ablehnen willst,"
					puts "da musst du mich noch lang nich haun! Das gibt Haue!!"
					self.boss.duell($du, 1)
				elsif qterw == 7
					puts "#{@name}: �� WA HAUSCH MISCH? i willte eischlisch dei boxa zusammehaue,"
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
			next if g.object_id == @boss.object_id
			g.boxer.each do |bx|
				next if bx.heraus == 0
				pbx = (((bx.schnelligkeit + bx.aufwaermen) / 2).to_i) * 7 + ((bx.staerke / 10).to_i) * 4 + (((bx.kondition + bx.aufwaermen) / 2).to_i) * 4 + ((bx.konzentration/10).to_i) * 2 + ((bx.gewicht - 62)/25).to_i
				if rand(8) < pself - pbx
					wahl = 0
					loop do
						print "Willst du das Duell #{@name}s gegen #{bx.name}"
						print ", den Boxer von #{bx.boss.name}, " unless self.object_id == @boss.object_id
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
			puts "#{@name} ist zu unkonzentriert, um mit dem H�ndler zu verhandeln!"
			return
		end
		if @muedigkeit < 10
			puts "#{@name} ist zu m�de dazu!"
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
				puts "#{i} = #{e} f�r #{kosten[i]}.00 Fr."
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
					puts "#{i} = #{e} f�r #{@wkosten[i]}.00 Fr."
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
				puts "#{@name} freut sich gar nicht, dass er seine Lieblingswaffe hat abgeben m�ssen!"
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
			puts "#{@name} ist zu unkonzentriert, um mit dem H�ndler zu verhandeln!"
			return
		end
		if @muedigkeit < 10
			puts "#{@name} ist zu m�de dazu!"
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
				puts "#{i} = #{e} f�r #{kosten[i]}.00 Fr."
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
						puts "#{i} = #{e} f�r #{@wkosten[i]}.00 Fr."
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
			puts "#{@name} #{@b}ist zu m�de dazu!" if @kijn == 0
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
			puts "#{@name} #{@b}ist zu m�de dazu!" if @kijn == 0
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
			puts "#{@name} ist zu m�de dazu!" if @kijn == 0
			return
		end
		if @geld < 70
			puts "#{@name} hat ja gar kein Geld! Er darf nicht essen! Rrraus!!" if @kijn == 0
			return
		end
		@gewicht += ((rand(3) + rand(3))/10.0) if @hunger > 10
		@geld -= rand(70) if @hunger > 10
		puts "Mampf, mjam, schleck, mmh!" if @kijn == 0 and @hunger > 10
		puts "B��h, kein Hunger!" if @kijn == 0 and @hunger <= 10
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
			puts "#{@name} #{@b}ist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 2
			puts "#{@name} #{@b}ist zu wenig aufgew�rmt, um hiermit effektiv trainieren zu k�nnen." if @kijn == 0
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
			puts "#{@name} #{@b}ist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 2
			puts "#{@name} #{@b}ist zu wenig aufgew�rmt, um hiermit effektiv trainieren zu k�nnen." if @kijn == 0
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
			puts "#{@name} #{@b}ist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 2
			puts "#{@name} #{@b}ist zu wenig aufgew�rmt, um hiermit effektiv trainieren zu k�nnen." if @kijn == 0
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
		puts "#{@name} macht Krafttraining. Nachher ist er nat�rlich hungrig und m�de." if @kijn == 0
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
			puts "#{@name} #{@b}ist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 4
			puts "#{@name} #{@b}ist zu wenig aufgew�rmt dazu." if @kijn == 0
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
		print "Du" if self.object_id == @boss.object_id and @kijn == 0
		print "Er" if not self.object_id == @boss.object_id and @kijn == 0
		print " ha#{@s}t nun alles m�gliche besser" if @kijn == 0
		print ", aber Spass macht ihm das gar nicht" if @kijn == 0 and not @boss.object_id == self.object_id
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
			puts "#{@name} #{@b}ist zu m�de dazu!" if @kijn == 0
			return
		end
		@konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
		@konzentrationsfaehigkeit += rand(200) / 100.0
		puts "#{@name} mach#{@s}t komische Konzentrations�bungen." if @kijn == 0
	end
	def zauberer
		@dehnbarkeit = 0
		@aufwaermen = 0
		if @freude < 5
			puts "#{@name} m�chte nicht zum Zauberer gehen." if @kijn == 0
			return
		end
		if @konzentration < 18
			puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um DEM ZAUBERER ZUZUH�REN braucht es nicht extrem viel Konzentration)" if @kijn == 0
			return
		end
		if @geld < 70
			puts "DuUUUU wiLLLst MicH betRR�gen? DUhasSSST ja Gar kEin gEld." if @kijn == 0
			puts "Daf��r laSSTet mein Fluch AB jETzt auf dIIER." if @kijn == 0
			puts "#{@name} hat nun sehr grosse Angst und ist psychisch v�llig fertig." if @kijn == 0
			@motivation = 0
			@freude = 0
		end
		if @muedigkeit < 10
			puts "#{@name} ist zu m�de dazu!" if @kijn == 0
			return
		end
		@motivation += (rand(21)/10.0) if @motivation < 100
		@geld -= rand(70)
		puts "SooOo meIN SoHn, dUUUUU bist aLsOO traurig? Dannn zuber ich dich gutt. NuN biSt dUUU dea BA�STE!" if @kijn == 0
	end
	def filmschaun
		@dehnbarkeit = 0
		@aufwaermen = 0
		if @konzentration < 15
			puts "#{@name} ist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um EINEN FILM ZU SCHAUEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
			return
		end
		if @muedigkeit < 5
			puts "#{@name} ist zu m�de dazu!" if @kijn == 0
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
		puts "Der Film gef�llt dem Boxer sehr. Dir ist er eigentlich zu doof. Das hat nat�rlich auch seinen Preis: Der Eintritt ist teuer." if @kijn == 0
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
		puts "St�rkestufe: #{@staerke}"
		puts "Aufgew�rmtheitsstufe: #{@aufwaermen}"
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
			puts "#{@name} ist zu m�de dazu!" if @kijn == 0
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
		puts "B��h, kein Hunger!" if @kijn == 0 and @hunger <= 10
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
		if @name.object_id == $du.name.object_id
			ieser = "u"
			ihn = "dich"
		end
		unless gegner.object_id == $du.object_id
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
					puts "was #{gegner.name} jedoch aus purem Gl�ck �berleb#{gegner.s}t." if kommentarejn == 1
					return
				elsif w6 == 2 and not @st > gegner.w + 1 and not gegner.object_id == $du.object_id
					puts "was #{gegner.name} jedoch aus unbekannten Gr�nden nichts ausmacht." if kommentarejn == 1
					return
				elsif w6 == 2 and not @st > gegner.w + 1
					puts "was dir jedoch aus unbekannten Gr�nden nichts ausmacht." if kommentarejn == 1
					return
				elsif w6 == 3 and not @st > gegner.w and not gegner.object_id == $du.object_id
					puts "was #{gegner.name} jedoch nicht verwundet." if kommentarejn == 1
					return
				elsif w6 == 3 and not @st > gegner.w
					puts "was dich jedoch nicht verwundet." if kommentarejn == 1
					return
				elsif w6 == 4 and gegner.w > @st	
					puts "was #{gegner.name} mit einem L�cheln quittier#{gegner.s}t." if kommentarejn == 1
					return
				elsif w6 == 5 and gegner.w > @st + 1
					puts "#{gegner.name} jedoch lach#{gegner.s}t nur �ber diesen schwachen Schlag." if kommentarejn == 1
					return
				elsif w6 == 6 and gegner.w > @st + 3
					puts "was #{gegner.name} jedoch nicht bemerk#{gegner.s}t." if kommentarejn == 1
					return
				end
			end
		end
		unless @waffent.include? "r�stungsbrechender Meisterhandschuh"
			wiederholung = 1
			wiederholung = 2 if gegner.amulette.include? "Gromrilamulett"
			wiederholung.times do
				w6 = 1 + rand(6)
				if w6 == 2 and gegner.rw <= 2
					print "was aber an " if kommentarejn == 1
					print "#{gegner.name}s" if kommentarejn == 1 and not gegner.object_id == $du.object_id
					print "deiner" if kommentarejn == 1 and gegner.object_id == $du.object_id
					puts " �berquillender Fettmasse nicht vorbeikommt." if kommentarejn == 1
					return
				elsif w6 == 3 and gegner.rw <= 3
					print "was aber in " if kommentarejn == 1
					print "#{gegner.name}s" if kommentarejn == 1 and not gegner.object_id == $du.object_id
					print "deinem" if kommentarejn == 1 and gegner.object_id == $du.object_id
					puts " schwabbelndem Fett steckenbleibt." if kommentarejn == 1
					return
				elsif w6 == 4 and gegner.rw <= 4
					print "der Schlag wird aber von " if kommentarejn == 1
					print "#{gegner.name}s" if kommentarejn == 1 and not gegner.object_id == $du.object_id
					print "deinem" if kommentarejn == 1 and gegner.object_id == $du.object_id
					puts " Fett derart abgebremst, dass er ihn nicht mehr verletzt." if kommentarejn == 1
					return
				elsif w6 == 5 and gegner.rw <= 5
					print "der Schlag macht " if kommentarejn == 1
					print gegner.name if kommentarejn == 1 and not gegner.object_id == $du.object_id
					print "dir" if kommentarejn == 1 and gegner.object_id == $du.object_id
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
		puts "und er verwundet #{gegner.name}!!! Nun hat dieser nur noch #{gegner.lp} Lebenspunkte!" if kommentarejn == 1 and not gegner.object_id == $du.object_id and not @name.object_id == $du.name.object_id
		puts "und er verwundet dich!!! Nun hast du nur noch #{$du.lp} Lebenspunkte!" if kommentarejn == 1 and gegner.object_id == $du.object_id
		puts "und du verwundest #{gegner.name}!!! Nun hat dieser nur noch #{gegner.lp} Lebenspunkte!" if kommentarejn == 1 and @name.object_id == $du.name.object_id
		if rand(@hk) > rand(gegner.lp + gegner.wk) or @waffent.include? "Meisterhandschuh des Hasses"
			puts "#{gegner.name} ist nun so zusammengeboxt, dass er nun schlechter k�mpft." if kommentarejn == 1
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
		@st += 1 if @waffent.include? "Handschuh der St�rke"
		@st += 2 if @waffent.include? "Donnermeisterhandschuh"
		gegner.st = 1 + (gegner.staerke / 10).to_i
		gegner.st += 1 if gegner.waffent.include? "Handschuh der St�rke"
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
		@rw -= 1 if @amulette.include? "Amulett der R�stung"
		@rw -= 2 if @amulette.include? "st�hlernes Amulett"
		gegner.rw = 6
		4.times do |e|
			gegner.rw -= 1 if gegner.gewicht - 75 - (25 * e) >= 0
		end
		gegner.rw -= 1 if gegner.amulette.include? "Amulett der R�stung"
		gegner.rw -= 2 if gegner.amulette.include? "st�hlerner Amulett"
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
		@ak += 2 if @amulette.include? "Amulett der Aufstehkraft" or @amulette.include? "Amulett der Unersch�tterlichkeit"
		@ak *= 2 if @amulette.include? "Amulett der Unersch�tterlichkeit"
		gegner.ak = ((gegner.motivation / 10 + gegner.kraft - gegner.gewicht / 10 - gegner.hunger / 10 + gegner.muedigkeit / 10) / 2).to_i
		gegner.ak += 2 if gegner.amulette.include? "Amulett der Aufstehkraft" or gegner.amulette.include? "Amulette"
		gegner.ak *= 2 if gegner.amulette.include? "Amulett der Unersch�tterlichkeit"
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
						puts "#{@name} #{@b}ist wieder aufgestanden und st�rtz#{@s}t " if kommentarejn == 1
						print "s" if not self.object_id == $du.object_id and kommentarejn == 1
						print "d" if self.object_id == $du.object_id and kommentarejn == 1
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
					print "#{gegner.name} ha#{gegner.s}t gewonnen!" unless kommentarejn == 0 and gegner.object_id == $boxhandel.object_id
					puts $overhau[0 - @lp] unless kommentarejn == 0 and gegner.object_id == $boxhandel.object_id
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
						puts "#{gegner.name} #{gegner.b}ist wieder aufgestanden und st�rtz#{gegner.s}t sich nun erneut in den Kampf!!" if kommentarejn == 1
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
					print "#{@name} ha#{@s}t gewonnen!" unless kommentarejn == 0 and gegner.object_id == $boxhandel.object_id
					puts $overhau[0 - gegner.lp] unless kommentarejn == 0 and gegner.object_id == $boxhandel.object_id
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
				puts "UNENTSCHIEDEN!!!!!!!!" unless kommentarejn == 0 and gegner.object_id == $boxhandel.object_id

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
class Trainer < Boxer
	def initialize(eignername, kijn=1, name=1)
		@boss = self
		@boxer = [Boxer.new(self, name, kijn)]
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
		@s = "s" if self.object_id == $du.object_id
		@b = "b" if self.object_id == $du.object_id
		@t = "t" if self.object_id == $du.object_id
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
	attr_accessor "name"
	attr_accessor "motivation"
	attr_accessor "boxer"
	attr_accessor "kondition"
	attr_accessor "kraft"
	attr_accessor "geld"
	attr_accessor "staerke"
	attr_accessor "aufwaermen"
	attr_accessor "konzentration"
	attr_accessor "schnelligkeit"
	attr_accessor "muedigkeit"
	attr_accessor "hunger"
	attr_accessor "gewicht"
	attr_accessor "dehnbarkeit"
	attr_accessor "kijn"
	attr_accessor "heraus"
	attr_accessor "b"
	attr_accessor "s"
	attr_accessor "waffen"
	attr_accessor "waffent"
	attr_accessor "b"
	attr_accessor "s"
	attr_accessor "st"
	attr_accessor "ak"
	attr_accessor "init"
	attr_accessor "agr"
	attr_accessor "w"
	attr_accessor "wk"
	attr_accessor "hk"
	attr_accessor "kg"
	attr_accessor "rw"
	attr_accessor "lp"
	attr_accessor "amulette"
	attr_accessor "kosten"
	def ctrunde(i)
		if not @name == "Kolibri" or not rand(4) == 0
			$gegner[i] = Trainer.new(@name) if self.crunde == 1
		end
		if @name == "Elch"
			$gegner[i] = Trainer.new(@name) if self.crunde == 1
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
		puts "2 = Rennen (Kondition/Aufw�rmen)"
		puts "3 = Essen (Gewicht)"
		puts "4 = In den kleinen Boxsack boxen (Schnelligkeit)"
		puts "5 = In den grossen Boxsack boxen (St�rke)"
		puts "6 = Krafttraining (Kraft, St�rke, Kondition)"
		puts "8 = Dehnen (Alles m�gliche)"
		puts "9 = Yoga (Konzentration)"
		puts "12 = Testen (genau wissen, wie gut er ist)"
		puts "13 = Aufh�ren (Nicht mehr zusehen m�ssen, wie der Compi viel besser ist als du(!!!!))"
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
				puts "Ich hab keinen gefunden, die Kosten will ich nat�rlich trotzdem bezahlt haben." if @kijn == 0
				kosten = 300 + rand(200)
				@geld -= kosten
				$boxhandel.geld += kosten
				return
			elsif rand(4) == 0
				name[rand(name.length)] = ($vokale + $konsonanten)[rand(($vokale + $konsonanten).length)] if @kijn == 0
				puts "Ich hab zwar einen extrem super Guten gefunden, der #{name} heisst, aber den willst du ja nicht, denn er hat nicht den gew�nschten Namen." if @kijn == 0
				@geld -= 300 + rand(200)
				return
			else
				puts "Hab keinen gefunden..." if @kijn == 0
				sleep(1)
				puts "HEY!!! Das ist noch lang kein Grund mich zu hauen!! Willst du Schl�ge?" if @kijn == 0
				sleep(1)
				self.duell($boxhandel, (1 - @kijn))
				return
			end
		end
		@boxer.push Boxer.new(self, name, @kijn)
		kosten = 3000 + rand(2000)
		@geld -= kosten
		$boxhandel.geld += kosten
		puts "Oh, ja! Ich habe hier zuf�llig einen ziemlich Guten gefunden, der sogar zuf�llig \"#{name}\" heisst." if @kijn == 0
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
			puts "Du bist zu m�de dazu!" if @kijn == 0
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
		puts "Du probierst verzweifelt, seilzuspringen, schaffst es aber nie mehr als f�nf Mal." if @kijn == 0
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
			puts "Du bist zu m�de dazu!" if @kijn == 0
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
		puts "Du joggst ein kleines St�ckchen, dann f�llst du um vor M�digkeit." if @kijn == 0
	end
	def essen
		@dehnbarkeit = 0
		@aufwaermen = 0
		if @konzentration < 10
			puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
			return
		end
		if @muedigkeit < 5
			puts "Du bist zu m�de dazu!" if @kijn == 0
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
			puts "Du bist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 2
			puts "Du bist zu wenig aufgew�rmt, um hiermit effektiv trainieren zu k�nnen." if @kijn == 0
			return
		end
		@schnelligkeit += (rand(5)/50.0)
		@schnelligkeit += @aufwaermen/50.0
		@gewicht -= (rand(100)/1000.0)
		@aufwaermen += rand(20)/10.0
		@hunger += rand(3)
		@muedigkeit -= rand(3)
		@dehnbarkeit += rand(5)/10.0
		puts "B�mmele..b�b�mmele..b�b�mmele..b�b�mmele ..b�mmeleb�mmele..b�mmele..b�b�mmele..." if @kijn == 0
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
			puts "Du bist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 2
			puts "Du bist zu wenig aufgew�rmt, um hiermit effektiv trainieren zu k�nnen." if @kijn == 0
			return
		end
		@staerke += (rand(5)/50.0)
		@staerke += @aufwaermen/50.0
		@gewicht -= (rand(200)/1000.0)
		@aufwaermen += rand(20)/20.0
		@hunger += rand(5)
		@muedigkeit -= rand(5)
		@dehnbarkeit += rand(10)/10.0
		puts "dong!.....batz!..d�ff!....doing!..." if @kijn == 0
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
			puts "Du bist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 2
			puts "Du bist zu wenig aufgew�rmt, um hiermit effektiv trainieren zu k�nnen." if @kijn == 0
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
		puts "Du machst nat�rlich leichteres Krafttraining als der Boxer, nach ein paar Liegest�tzen bist du schon v�llig KO." if @kijn == 0
	end
	def dehnen
		if @konzentration < 15
			puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um zu DEHNEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
			return
		end
		if @muedigkeit < 10
			puts "Du bist zu m�de dazu!" if @kijn == 0
			return
		end
		if @aufwaermen < 4
			puts "Du bist zu wenig aufgew�rmt dazu." if @kijn == 0
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
			puts "Du bist zu m�de dazu!" if @kijn == 0
			return
		end
		@konzentration += rand(21) if @konzentration < @konzentrationsfaehigkeit
		@konzentrationsfaehigkeit += rand(200) / 100.0
		puts "Du machst komische Konzentrations�bungen." if @kijn == 0
	end
	def testen
		puts "Konditionsstufe: #{@kondition}"
		puts "Gewicht: #{@gewicht} kg"
		puts "Schnelligkeitsstufe: #{@schnelligkeit}"
		puts "Geld: #{@geld}.00 Fr."
		puts "Kraftstufe: #{@kraft}"
		puts "St�rkestufe: #{@staerke}"
		puts "Aufgew�rmtheitsstufe: #{@aufwaermen}"
		puts "Konzentrationsstufe: #{@konzentration}"
		puts "Konzentrationsfaehigkeitsstufe: #{@konzentrationsfaehigkeit}"
		puts "Hunger: #{@hunger}"
		puts "Dehnbarkeitsstufe: #{@dehnbarkeit}"
		puts "Wachheitsstufe: #{@muedigkeit}"
		print "Boxer: "
		self.boxer.each_with_index {|boxers,i| print boxers.name, ", " if i < self.boxer.length - 1}
		puts "#{self.boxer[-1].name} und nat�rlich #{@name} selbst."
	end
	def fkessen
		@dehnbarkeit = 0
		@aufwaermen = 0
		if @konzentration < 10
			puts "Du bist zu unkonzentriert dazu!", "(JA, du siehst das RICHTIG: um ZU ESSEN braucht es nicht extrem viel Konzentration)" if @kijn == 0
			return
		end
		if @muedigkeit < 5
			puts "Du bist zu m�de dazu!" if @kijn == 0
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
$boxhandel = Trainer.new("Boxerverk�ufer")
$gegner = [Trainer.new("Kolibri"), Trainer.new("Rentier"), Trainer.new("Biber"), Trainer.new("Fledermaus"), Trainer.new("Fuchs"), Trainer.new("Hase"), Trainer.new("Igel"), Trainer.new("Wolf"), Trainer.new("Elch")]
$gegner.each {|g| print g.boxer[0].name, " ist der Boxer vom ", g.name, "\n"}
puts "Du sollst auch einen Boxer trainieren. Wie soll er heissen?"
$du = Trainer.new("Du", 0, gets.chomp)
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
		].each {|thread| thread.join}
		if duellrunde == runde
			puts "_______________________________________________________________________________________________"
			puts
			puts "DUELLRUNDE:"
			$gegner.each_with_index do |g,i|
				g.cherausfordern
			end
			$boxhandel.crunde
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
puts "					 DU:"
puts "					_____"
puts
$du.testen
puts "_______________________________________________________________________________________________"
puts
puts "                   ....und deine Boxer:"	
$du.boxer.each do |b|
	puts "_______________________________________________________________________________________________"
	puts
	puts
	puts "					 #{b.name}:"
	print "					___"; b.name.length.times {print "_"}; puts
	puts
	b.testen
end
$gegner.each do |g|
	puts "_______________________________________________________________________________________________"
	puts
	puts
	puts "					 #{g.name}:"
	print "					___"; g.name.length.times {print "_"}; puts
	puts
	g.testen
	puts "_______________________________________________________________________________________________"
	puts
	puts "                   ....und seine Boxer:"	
	g.boxer.each do |b|
		puts "_______________________________________________________________________________________________"
		puts
		puts
		puts "					 #{b.name}:"
		print "					___"; b.name.length.times {print "_"}; puts
		puts
		b.testen
	end
end