extends Control

signal results_shown

@onready var text_stuff = $text_stuff
@onready var bottom_text = $bottom_bar/bottom_text

var stat : Array[PackedStringArray]
var stat_given : Array[int]

var stat_page_0 : Array[String]

var is_active := false
var curr_page := 0

func _ready():
	stat.resize(10) # I need to do this to avoid copy pasting a lot of text.
	stat_given.resize(10)
	for i in 10:
		stat[i] = PackedStringArray()
		stat[i].resize( 21 ) # 20 is being lazy
	
	stat_given[0] = randi_range(0,20);
	stat_given[1] = randi_range(0,13);
	stat_given[2] = randi_range(0,10);
	stat_given[3] = randi_range(0,13);
	stat_given[4] = randi_range(0,15);
	stat_given[5] = randi_range(0,10);
	stat_given[6] = randi_range(0,14);
	stat_given[7] = randi_range(0,10);
	stat_given[8] = randi_range(0,14);
	stat_given[9] = randi_range(0,14);
	
	# Save stupid data.
	B2_Playerdata.character_scanner = stat_given
	
	#stat_page_0.resize( 7 )
	
	stat_page_0.append("Age:");
	stat_page_0.append("Race:");
	stat_page_0.append("Sacred lineage:");
	stat_page_0.append("Body type:");
	stat_page_0.append("Personality type:");
	stat_page_0.append("Elemental affinity:");
	stat_page_0.append("Weapon of choice:");
	
#region text db
	##// Stats][AGE //
	stat[0][0] = "1";
	stat[0][1] = "2";
	stat[0][2] = "3";
	stat[0][3] = "14";
	stat[0][4] = "15";
	stat[0][5] = "16";
	stat[0][6] = "17";
	stat[0][7] = "18";
	stat[0][8] = "19";
	stat[0][9] = "20";
	stat[0][10] = "21";
	stat[0][11] = "22";
	stat[0][12] = "23";
	stat[0][13] = "24";
	stat[0][14] = "25";
	stat[0][15] = "26";
	stat[0][16] = "27";
	stat[0][17] = "28";
	stat[0][18] = "33";
	stat[0][19] = "69";
	stat[0][20] = "666";

	# // Stats][RACE //
	stat[1][0] = "U.F.O.";
	stat[1][1] = "Teen";
	stat[1][2] = "Kitsune";
	stat[1][3] = "Transhumanist";
	stat[1][4] = "Cyborg";
	stat[1][5] = "U.S.A.";
	stat[1][6] = "Gamer";
	stat[1][7] = "N/A.";
	stat[1][8] = "Posthuman";
	stat[1][9] = "Subhuman";
	stat[1][10] = "Neanderthal";
	stat[1][11] = "Other";
	stat[1][12] = "Otherkin";
	stat[1][13] = "Slime Cube"

	# // Stats][SACRED LINEAGE //
	stat[2][0] = "Daffy Duck";
	stat[2][1] = "George Washington Carver";
	stat[2][2] = "Crispus Attucks";
	stat[2][3] = "Chang and Eng Bunker";
	stat[2][4] = "Treant blood";
	stat[2][5] = "Merlin";
	stat[2][6] = "The Circus";
	stat[2][7] = "Dracula";
	stat[2][8] = "Aleister Crowley";
	stat[2][9] = "King Tut";
	stat[2][10] = "Genghis Khan";

	# // Stats][BODY TYPE //
	stat[3][0] = "Jock";
	stat[3][1] = "Otaku";
	stat[3][2] = "Greasy";
	stat[3][3] = "Baller";
	stat[3][4] = "U.F.O.";
	stat[3][5] = "Pear shaped";
	stat[3][6] = "Corpulent";
	stat[3][7] = "Puerile";
	stat[3][8] = "Pre-pubescent";
	stat[3][9] = "Fecund";
	stat[3][10] = "Stout";
	stat[3][11] = "Infirm";
	stat[3][12] = "Elderly";
	stat[3][13] = "Delicate";

	# // Stats][PERSONALITY //
	stat[4][0] = "Tough & Cool";
	stat[4][1] = "Bad Boy";
	stat[4][2] = "Gamer";
	stat[4][3] = "Goofster";
	stat[4][4] = "Rapster";
	stat[4][5] = "Rando";
	stat[4][6] = "Honorable";
	stat[4][7] = "Pious";
	stat[4][8] = "Circus Lover";
	stat[4][9] = "Daffy";
	stat[4][10] = "Churlish";
	stat[4][11] = "Train Conductor";
	stat[4][12] = "Bananas";
	stat[4][13] = "Ethnic";
	stat[4][14] = "Unbeugsam";
	stat[4][15] = "Teutonic";

	# // Stats][ELEMENTAL AFFINITY //
	stat[5][0] = "Vidcons";
	stat[5][1] = "Candy";
	stat[5][2] = "Doo Wop";
	stat[5][3] = "Cartoons";
	stat[5][4] = "Toys";
	stat[5][5] = "Ooze";
	stat[5][6] = "Sewage";
	stat[5][7] = "Corn";
	stat[5][8] = "Muscles";
	stat[5][9] = "B-Ball";
	stat[5][10] = "Trains";

	# // Stats][Weapon of Choice //
	stat[6][0] = "Katana";
	stat[6][1] = "Morgenstern";
	stat[6][2] = "Flammenschwert";
	stat[6][3] = "Ahlspeiss";
	stat[6][4] = "Ranseur";
	stat[6][5] = "Zweihander";
	stat[6][6] = "Voulge";
	stat[6][7] = "Guisarme";
	stat[6][8] = "Weapons? Heh, I don't need#weapons... only my Jeet Kune Do. ";
	stat[6][9] = "Baselard";
	stat[6][10] = "Dual wielded kriegsflegels";
	stat[6][11] = "Schweizersabel";
	stat[6][12] = "Braquemard";
	stat[6][13] = "Reitschwert";
	stat[6][14] = "Grobes Messer";

	# // Stats][POLITICAL BELIEF //
	stat[7][0] = "Candy for the homeless";
	stat[7][1] = "Why do the poor always cause trouble?";
	stat[7][2] = "Dwarfs should NOT vote!";
	stat[7][3] = "Circumcise the poor";
	stat[7][4] = "Gamers are the ultimate life form";
	stat[7][5] = "Afrofuturism";
	stat[7][6] = "Exploit the poor for candy";
	stat[7][7] = "People are just stepping stones on my#quest for more vidcons";
	stat[7][8] = "Politics don't concern me... only web comics.";
	stat[7][9] = "Separation of vidcons and state";
	stat[7][10] = "Total Apocalyptic Ideals";

	# // Stats][DISTINCTI E PHYSICAL FEATURE //
	stat[8][0] = "Lactation";
	stat[8][1] = "Completely hairless";
	stat[8][2] = "No arms";
	stat[8][3] = "Birthmark on torso that spells out#'Cirque du Soleil'";
	stat[8][4] = "Significant applebottom";
	stat[8][5] = "Spacious urethra";
	stat[8][6] = "Born without a groin";
	stat[8][7] = "Tiny head";
	stat[8][8] = "Childbearing hips";
	stat[8][9] = "Enormous head";
	stat[8][10] = "Immaculate high top fade";
	stat[8][11] = "Jean shorts grafted to body in a fire";
	stat[8][12] = "Body odor attracts hound dogs";
	stat[8][13] = "Corn cob genitals";
	stat[8][14] = "100% sunburnt"

	# // Stats][PERSONAL QUOTE //
	stat[9][0] = "I'll grind your bones to make my bread.";
	stat[9][1] = "Homework is last bastion of the ignorant."
	stat[9][2] = "You don't need a reason to help people."
	stat[9][3] = "Semper games."
	stat[9][4] = "...fools."
	stat[9][5] = "Your radical ideas about society, individualism,#and religion have already occurred to others.#The fact that someone thinks the absurd things#you produce make some kind of lame societal#statement doesn't mean you're an artist."
	stat[9][6] = "I don't want to fight... but I'll do it to#protect my friends."
	stat[9][7] = "doki doki can be in talk of love in Japan#witch it throbbing heart ##(a sound fx)"
	stat[9][8] = "Ya'll ready to stop? No? Ya'll wanna know#why? Why? Cuz. It's. The Slam Jam."
	stat[9][9] = "I'm a gamer psycho mercenary who will kill#you at the drop of a hat. And hats drop easy#in this fucked up world."
	stat[9][10] = "The only thing sharper than my katana...#is my tongue."
	stat[9][11] = "The bond I share with dragons is unbreakable."
	stat[9][12] = "I revel in the flames of chaos. Dance, puppets,#DANCE!!!"
	stat[9][13] = "Trust in Clispaeth and He will reward you." 
	stat[9][14] = "Let's Plays don't make themselves." 
	
#endregion
	
	# show_result() ## DEBUG

func show_result():
	is_active = true
	populate_page()
	
func next_page():
	curr_page += 1
	populate_page()
	
# // Pages //
func populate_page():
	if curr_page >= 3:
		results_shown.emit()
		is_active = false
		hide()
	else:
		bottom_text.text = Text.pr( "Page " + str( curr_page + 1 ) + " out of 3" )
		
		## Cleanup.
		for i in text_stuff.get_children():
			i.queue_free()
		
		match curr_page:
			0:
				for i in 7:
					var title_label := Label.new()
					var stat_label := Label.new()
					
					text_stuff.add_child( title_label )
					text_stuff.add_child( stat_label )
					
					title_label.text 	= Text.pr( stat_page_0[i] )
					stat_label.text 	= Text.pr( stat[ i ][ stat_given[ i ] ] )
					
					title_label.modulate = Color.RED
					
					title_label.global_position = Vector2( 27, 100 + i * 16 )
					stat_label.global_position = Vector2( 163, 100 + i * 16 )
			1:
				## Title
				var pb_label := Label.new()
				var pf_label := Label.new()
				
				text_stuff.add_child( pb_label )
				text_stuff.add_child( pf_label )
				
				pb_label.text 	= Text.pr( "Political beliefs:" )
				pf_label.text 	= Text.pr( "Distinctive physical features:" )
				
				pb_label.modulate = Color.YELLOW
				pf_label.modulate = Color.YELLOW
				
				pb_label.global_position = Vector2(27, 100)
				pf_label.global_position = Vector2(27, 154)
				## Result
				var pb_result_label := Label.new()
				var pf_result_label := Label.new()
				
				text_stuff.add_child( pb_result_label )
				text_stuff.add_child( pf_result_label )
				
				pb_result_label.text 	= Text.pr( "- " + stat[ 7 ][ stat_given[ 7 ] ] )
				pf_result_label.text 	= Text.pr( "- " + stat[ 8 ][ stat_given[ 8 ] ] )
				
				pb_result_label.global_position = Vector2(27, 118) # was Vector2(35, 118) in the original
				pf_result_label.global_position = Vector2(27, 172) # was Vector2(35, 172) in the original
			2:
				var quote_label := Label.new()
				text_stuff.add_child( quote_label )
				quote_label.text 	= Text.pr( "Personal quote:" )
				quote_label.global_position = Vector2( 27, 100 )
				quote_label.modulate = Color.TEAL
				
				var quote_result_label := Label.new()
				text_stuff.add_child( quote_result_label )
				quote_result_label.text 	= Text.pr( '"' + stat[ 9 ][ stat_given[ 9 ] ] + '"' )
				quote_result_label.global_position = Vector2( 35, 118 )
	
func _process(_delta):
	if is_active:
		if Input.is_action_just_pressed("Action"):
			next_page()
