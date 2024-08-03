extends Control

signal pressed_accept

enum MODE{LIKE, FAVORITE}
#var curr_MODE := MODE.FAVORITE
var curr_MODE := MODE.LIKE

@onready var category_label = $category_label
@onready var selection_label = $selection_label

@onready var category_btn = $category_btn
@onready var selection_btn = $selection_btn

var option_likes : Array
var option_favorites : Array

var selection_category := 0
var selection_like : Array[int]
var selection_favorite : Array[int]

func _ready():
	category_label.text = Text.pr( "Category" )
	selection_label.text = Text.pr( "Selection" )
	category_label.position = Vector2( 19, 13 )
	selection_label.position = Vector2( 131, 13 )
	
	selection_like.resize( 		9 )
	#selection_like.fill( 		100000 )
	selection_favorite.resize( 	9 )
	#selection_favorite.fill( 	100000 )
	
	option_likes.resize( 9 )
	for i in 9:
		option_likes[i] = Array()
		option_likes[i].resize( 14 )
		
	option_favorites.resize( 7 )
	for i in 7:
		option_favorites[i] = Array()
		option_favorites[i].resize( 14 )
	
#region data
	# // Likes // 12 x 9 = 108 - there are 32 genes 64 96 - exluced = 118 / 4 = 29
	option_likes[0] [0] = false;
	option_likes[0] [1] = "Food"; # // 12
	option_likes[0] [2] = "Bean";
	option_likes[0] [3] = "Oat";
	option_likes[0] [4] = "Power Bar";
	option_likes[0] [5] = "Fig";
	option_likes[0] [6] = "Gum";
	option_likes[0] [7] = "Sauce";
	option_likes[0] [8] = "Buffalo Wing";
	option_likes[0] [9] = "Graham Cracker";
	option_likes[0] [10] = "Sorghum";
	option_likes[0] [11] = "Nugget";
	option_likes[0] [12] = "Salted Cracker";
	option_likes[0] [13] = "Unsalted Cracker";

	option_likes[1] [0] = false;
	option_likes[1] [1] = "Footwear"; # // 12
	option_likes[1] [2] = "Moccasin";
	option_likes[1] [3] = "Sandals";
	option_likes[1] [4] = "Otzi the Iceman's shoes";
	option_likes[1] [5] = "Flip-flop";
	option_likes[1] [6] = "Espadrilles";
	option_likes[1] [7] = "Pattens";
	option_likes[1] [8] = "Soles";
	option_likes[1] [9] = "Slippers";
	option_likes[1] [10] = "Flippers";
	option_likes[1] [11] = "Socks";
	option_likes[1] [12] = "Snowshoes";
	option_likes[1] [13] = "Peg legs";

	option_likes[2] [0] = false;
	option_likes[2] [1] = "Battle Tactic"; # // 12
	option_likes[2] [2] = "Raucous Hoot";
	option_likes[2] [3] = "Sommersault";
	option_likes[2] [4] = "Knuckle Sandwich";
	option_likes[2] [5] = "Battle Juggling";
	option_likes[2] [6] = "Swoop Attack";
	option_likes[2] [7] = "Boomerang Throw";
	option_likes[2] [8] = "War Bops";
	option_likes[2] [9] = "Operation Ground and Pound";
	option_likes[2] [10] = "Magician Orb";
	option_likes[2] [11] = "Jumping Jack (to build vigor)";
	option_likes[2] [12] = "Crawling on Ground to Surprise Foes";
	option_likes[2] [13] = "Peacefare";

	option_likes[3] [0] = false;
	option_likes[3] [1] = "Class"; # // 12
	option_likes[3] [2] = "History";
	option_likes[3] [3] = "Geography";
	option_likes[3] [4] = "Social Studies";
	option_likes[3] [5] = "Geometry";
	option_likes[3] [6] = "Algebra";
	option_likes[3] [7] = "English";
	option_likes[3] [8] = "Language Arts";
	option_likes[3] [9] = "Pre-Algebra";
	option_likes[3] [10] = "Oceanography";
	option_likes[3] [11] = "Geology";
	option_likes[3] [12] = "Gym";
	option_likes[3] [13] = "Biology";

	option_likes[4] [0] = false;
	option_likes[4] [1] = "Sport"; # // 12
	option_likes[4] [2] = "Basketball";
	option_likes[4] [3] = "Hoop Ball";
	option_likes[4] [4] = "Hoop and Ball";
	option_likes[4] [5] = "College Hoop and Ball";
	option_likes[4] [6] = "Parahoop and Ball";
	option_likes[4] [7] = "Outdoor Hoop and Ball";
	option_likes[4] [8] = "Field Hoop and Ball";
	option_likes[4] [9] = "E-Hoop and Ball";
	option_likes[4] [10] = "Netball";
	option_likes[4] [11] = "Dunkball";
	option_likes[4] [12] = "Amateur Dunkball";
	option_likes[4] [13] = "Hoop'n'ball";

	option_likes[5] [0] = false;
	option_likes[5] [1] = "Class"; # // 12
	option_likes[5] [2] = "Fighter";
	option_likes[5] [3] = "Warrior";
	option_likes[5] [4] = "Barbarian";
	option_likes[5] [5] = "Knight";
	option_likes[5] [6] = "Skirmisher";
	option_likes[5] [7] = "Swordsman";
	option_likes[5] [8] = "Fencer";
	option_likes[5] [9] = "Gladiator";
	option_likes[5] [10] = "Brawler";
	option_likes[5] [11] = "Samurai";
	option_likes[5] [12] = "Boxer";
	option_likes[5] [13] = "Rodeo Clown";

	option_likes[6] [0] = false;
	option_likes[6] [1] = "Teacher"; # // 12
	option_likes[6] [2] = "Ms. Moody";
	option_likes[6] [3] = "Mr. Helwig";
	option_likes[6] [4] = "Sra. Primavera";
	option_likes[6] [5] = "Mssr. Ehrlichmann";
	option_likes[6] [6] = "Mr. Pinschmidt";
	option_likes[6] [7] = "Herr Matula";
	option_likes[6] [8] = "Prof. Gupta";
	option_likes[6] [9] = "Sir Dilweg";
	option_likes[6] [10] = "Lt. Turner";
	option_likes[6] [11] = "Dr. Szekeras PhD";
	option_likes[6] [12] = "Mdm. Bellard";
	option_likes[6] [13] = "Mrs. Yamaguchi";

	option_likes[7] [0] = false;
	option_likes[7] [1] = "Star"; # // 12
	option_likes[7] [2] = "Sun";
	option_likes[7] [3] = "Proxima Centauri";
	option_likes[7] [4] = "Alpha Centauri C";
	option_likes[7] [5] = "Sirius B";
	option_likes[7] [6] = "R Doradus";
	option_likes[7] [7] = "VY Canis Majoris";
	option_likes[7] [8] = "OGLE-TR-122B";
	option_likes[7] [9] = "R136a1";
	option_likes[7] [10] = "PPI 15";
	option_likes[7] [11] = "PSR J1614-2230";
	option_likes[7] [12] = "Barnard's Star";
	option_likes[7] [13] = "North Star";

	option_likes[8] [0] = false;
	option_likes[8] [1] = "Animal"; # // 12
	option_likes[8] [2] = "Nightingale";
	option_likes[8] [3] = "Axolotl";
	option_likes[8] [4] = "Mole";
	option_likes[8] [5] = "Alligator";
	option_likes[8] [6] = "Falcon";
	option_likes[8] [7] = "Nutria";
	option_likes[8] [8] = "Rat";
	option_likes[8] [9] = "Tapir";
	option_likes[8] [10] = "Snail";
	option_likes[8] [11] = "Mandrill";
	option_likes[8] [12] = "Wyvern";
	option_likes[8] [13] = "Corndog";

	# // Dislikes // 72 total choices
	# //Two Racial Enemies
	option_favorites[0] [0] = false;
	option_favorites[0] [1] = "Racial foe 1"; # // 12
	option_favorites[0] [2] = "Mummies";
	option_favorites[0] [3] = "Ooze";
	option_favorites[0] [4] = "Bugbears";
	option_favorites[0] [5] = "Seagulls";
	option_favorites[0] [6] = "YouTube Let's Players";
	option_favorites[0] [7] = "Skulls";
	option_favorites[0] [8] = "Burglars";
	option_favorites[0] [9] = "Gamers";
	option_favorites[0] [10] = "Garfield";
	option_favorites[0] [11] = "Weresnails";
	option_favorites[0] [12] = "Wizards";
	option_favorites[0] [13] = "The Mystical Drakes";

	option_favorites[1] [0] = false;
	option_favorites[1] [1] = "Racial foe 2"; # // 12 = 24
	option_favorites[1] [2] = "Mummies";
	option_favorites[1] [3] = "Ooze";
	option_favorites[1] [4] = "Bugbears";
	option_favorites[1] [5] = "Seagulls";
	option_favorites[1] [6] = "YouTube Let's Players";
	option_favorites[1] [7] = "Skulls";
	option_favorites[1] [8] = "Burglars";
	option_favorites[1] [9] = "Gamers";
	option_favorites[1] [10] = "Garfield";
	option_favorites[1] [11] = "Weresnails";
	option_favorites[1] [12] = "Wizards";
	option_favorites[1] [13] = "The Mystical Drakes";

	option_favorites[2] [0] = false;
	option_favorites[2] [1] = "Phobia"; # // 12 = 36
	option_favorites[2] [2] = "Claustrophobia";
	option_favorites[2] [3] = "Agoraphobia";
	option_favorites[2] [4] = "Equinophobia";
	option_favorites[2] [5] = "Necrophobia";
	option_favorites[2] [6] = "Sitophobia";
	option_favorites[2] [7] = "Coulrophobia";
	option_favorites[2] [8] = "Entomophobia";
	option_favorites[2] [9] = "Zauberphobia";
	option_favorites[2] [10] = "Anthropophobia";
	option_favorites[2] [11] = "Albuminurophobia";
	option_favorites[2] [12] = "Metrophobia";
	option_favorites[2] [13] = "Selachophobia";

	option_favorites[3] [0] = false;
	option_favorites[3] [1] = "Zauber"; # // 12 = 48
	option_favorites[3] [2] = "Kilpert's Ice Arrow";
	option_favorites[3] [3] = "Lesser Mummification";
	option_favorites[3] [4] = "Turn Duergar";
	option_favorites[3] [5] = "Raise Vegetables";
	option_favorites[3] [6] = "Battlefield Spook";
	option_favorites[3] [7] = "Moonlight Muscle Level 7";
	option_favorites[3] [8] = "Patriot";
	option_favorites[3] [9] = "Summon Seagull III";
	option_favorites[3] [10] = "Identify Bugbear";
	option_favorites[3] [11] = "Jazz Toot";
	option_favorites[3] [12] = "Herbert's Healing Hands";
	option_favorites[3] [13] = "Remove Experience";

	option_favorites[4] [0] = false;
	option_favorites[4] [1] = "Landmarks"; # // 12 = 60
	option_favorites[4] [2] = "Pyramids of Giza";
	option_favorites[4] [3] = "Oatmeal Factory";
	option_favorites[4] [4] = "Leaning Tower of Pisa";
	option_favorites[4] [5] = "The Moon";
	option_favorites[4] [6] = "Stonehenge";
	option_favorites[4] [7] = "Mt. Rushmore";
	option_favorites[4] [8] = "GameStop";
	option_favorites[4] [9] = "ToG Studios";
	option_favorites[4] [10] = "Huge Cube";
	option_favorites[4] [11] = "Neo New York Harbor";
	option_favorites[4] [12] = "Statue of Clispaeth";
	option_favorites[4] [13] = "Corn Cob Colosseum";

	option_favorites[5] [0] = false;
	option_favorites[5] [1] = "Vidcon A"; # // 5 = 65
	option_favorites[5] [2] = "Midnight [xSLASH].eclipse ]|[";
	option_favorites[5] [3] = "Ziggurat Electron School";
	option_favorites[5] [4] = "B:LADe gEAR_x_Havoc";
	option_favorites[5] [5] = "Clown School 2"; # //lowers luck by 2
	option_favorites[5] [6] = "~F.A.T.E.~ _gain_ reveLation";

	option_favorites[6] [0] = false;
	option_favorites[6] [1] = "Vidcon C"; # // 7 = 72
	option_favorites[6] [2] = "Lanzenacht Mitsuru Geschtalten:#Chaos Children";
	option_favorites[6] [3] = "Alchemist Heart Baney#-=Divine Comedy=-";
	option_favorites[6] [4] = "B.I.O. Magician Ooze:#Escape from Brain City";
	option_favorites[6] [5] = "mIst-edge ~over the clouds#of wonder~";
	option_favorites[6] [6] = "BEAST Days <Slayer>:#High School Generation";
	option_favorites[6] [7] = "S.avan.T Rise D.N.A -#innocent crime R0ND0 -";
	option_favorites[6] [8] = "<[SolaR]> .rOmAnCiNg. ~#Grim XraptureX";
	
#endregion
	
	## Cleanup
	for i in 9:
		option_likes[i] 		= _clean_array( option_likes[i] )
	for i in 7:
		option_favorites[i] 	= _clean_array( option_favorites[i] )
	
	
	populate_category_menu()
	populate_selection_menu( selection_category )
	
func toggle_mode():
	if curr_MODE == MODE.FAVORITE:
		curr_MODE = MODE.LIKE
	else:
		curr_MODE = MODE.FAVORITE
	populate_category_menu()
		
func populate_category_menu():
	## Cleanup
	for child in category_btn.get_children():
		#if child.disconnect("pressed")
		child.queue_free()
	
	var option : Array
	if curr_MODE == MODE.FAVORITE:
		option = option_favorites
	else:
		option = option_likes
	
	var cat_btn_group := ButtonGroup.new()
	
	# Category populate
	for o in range( option.size() ):
		var button := Button.new()
		category_btn.add_child( button )
		button.size = Vector2( 91, 16 )
		button.position = Vector2( 19, 48 + o * 16 )
		if curr_MODE == MODE.FAVORITE:
			button.text = Text.pr( option_favorites[ o ] [ 1 ] )
		else:
			button.text = Text.pr( option_likes[ o ] [ 1 ] )
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.toggle_mode = true
		button.button_group = cat_btn_group
		button.pressed.connect( func(): populate_selection_menu( o ) )

func populate_selection_menu( sel_id : int ):
	selection_category = sel_id
	B2_Sound.play( "sn_cc_generic_button1" )
	
	var selection : Array
	var option : Array
	if curr_MODE == MODE.FAVORITE:
		selection 	= selection_favorite
		option 		= option_favorites
	else:
		selection 	= selection_like
		option 		= option_likes
	
	for child in selection_btn.get_children():
		child.queue_free()
		
	var sel_btn_group := ButtonGroup.new()
	
	# Selection populate
	for i in range( option[ selection_category ].size() - 2 ):
		var sel_button := Button.new()
		selection_btn.add_child( sel_button )
		
		if selection_category == 6 and curr_MODE == MODE.FAVORITE: # Vidcon C
			sel_button.size = Vector2(238, 24)
			sel_button.position = Vector2( 131, 46 + i * 25 )
		else:
			sel_button.size = Vector2(238, 16)
			sel_button.position = Vector2( 131, 48 + i * 15 )
		
		sel_button.text = Text.pr( option[ selection_category ] [ i + 2 ] )
		sel_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		sel_button.toggle_mode = true
		sel_button.button_group = sel_btn_group
		sel_button.pressed.connect( func(): select_item( selection_category, i ) )
		
		if selection[selection_category] == i:
			sel_button.button_pressed = true
		
		
func select_item( cat_id : int, sel_id : int):
	B2_Sound.play( "sn_cc_generic_button2" )
	if curr_MODE == MODE.FAVORITE:
		selection_favorite[cat_id] = sel_id
		B2_Playerdata.Quest("playerCCFaves" + str(cat_id + 1), var_to_str(sel_id + 2) );
	else:
		selection_like[cat_id] = sel_id
		B2_Playerdata.Quest("playerCCLikes" + str(cat_id + 1), var_to_str(sel_id + 2) );

func _clean_array( dirty_array : Array):
	var clean_array := []
	for item in dirty_array:
		if item != null:
			clean_array.append( item )
		else:
			print(item)
	return clean_array

func _on_review_btn_pressed():
	B2_Sound.play( "sn_cc_generic_button1" )
	
	for child in selection_btn.get_children():
		child.queue_free()
	
	var selection : Array
	var option : Array
	if curr_MODE == MODE.FAVORITE:
		selection 	= selection_favorite
		option 		= option_favorites
	else:
		selection 	= selection_like
		option 		= option_likes
		
	for i in range( option.size() ):
		var sel_button := Button.new()
		selection_btn.add_child( sel_button )
		
		sel_button.size = Vector2(238, 16)
		sel_button.position = Vector2( 131, 48 + i * 16 )
		
		sel_button.text = Text.pr( option[ i ] [ selection[ i ] + 2] )
		sel_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		sel_button.disabled = true

func _on_approve_btn_pressed():
	B2_Sound.play( "sn_cc_generic_button2" )
	pressed_accept.emit()
	
