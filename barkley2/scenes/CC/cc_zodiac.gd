@tool
extends Control

signal zodiac_entered

@onready var date_birth_label = $date_birth_label
@onready var date_birth_day_label = $date_birth_day_label
@onready var date_birth_month_label = $date_birth_month_label
@onready var date_birth_year_label = $date_birth_year_label

@onready var finish_button = $finish_button

@onready var pos_clispaeth_label = $pos_clispaeth_label
@onready var pre_clispaeth_label = $pre_clispaeth_label

@onready var hotspot_day: Control = $ring_day/hotspot_day

func _ready():
	# Set the position for everything
	# Due to the way im setting these labels, I cans use the original positions. Had to use these weird offsets
	date_birth_label.global_position 			= Vector2( 119, 206 ) - Vector2(45,0) 			#- date_birth_label.size / 2
	date_birth_day_label.global_position 		= Vector2( 82 + 10, 225 ) - Vector2(54,0) 		#- date_birth_day_label.size / 2 
	date_birth_month_label.global_position 		= Vector2( 109 + 10, 225) - Vector2(54,0) 		#- date_birth_month_label.size / 2
	date_birth_year_label.global_position 		= Vector2( 137 + 10 * 1, 225) - Vector2(45,0) 	#- date_birth_year_label.size / 2
	
	pos_clispaeth_label.global_position 		= Vector2(197, 206)
	pre_clispaeth_label.global_position 		= Vector2(197, 225)
	
	finish_button.pressed_finish.connect( finish_date_input )
	
	hotspot_day.grab_focus()
	
func finish_date_input():
	## parse data
	var z_era := 0
	var z_day := 0
	var z_month := 0
	var z_year := 0
	var z_zodiac := 0
	
	
	
	# no era selected. the original code forces a pos era as default.
	if pos_clispaeth_label.is_selected:
		z_era = 0
	elif pre_clispaeth_label.is_selected:
		z_era = 1
	
	# Lets get the sefult directly from the label, since its cleaner.
	z_day = int( date_birth_day_label.text )
	z_month = int( date_birth_month_label.text )
	z_year = int( date_birth_year_label.text )
	z_zodiac = z_month
	
	# save data on the player data autoload
	B2_Playerdata.character_zodiac = z_zodiac;
	B2_Playerdata.character_zodiac_year = z_year;
	B2_Playerdata.character_zodiac_month = z_month;
	B2_Playerdata.character_zodiac_day = z_day;
	B2_Playerdata.character_zodiac_era = z_era;
	
	B2_Playerdata.Quest("playerCCDay", str(z_day) );
	B2_Playerdata.Quest("playerCCMonth", str(z_month) );
	B2_Playerdata.Quest("playerCCYear", str(z_year) );
	B2_Playerdata.Quest("playerCCEra", str(z_era) );
	
	# the original code has a bunch of functions and settions related to Pax, but I have no idea what it does.
	
	print("Zodiac day: ",		z_day)
	print("Zodiac month: ",		z_month)
	print("Zodiac year: ",		z_year)
	print("Zodiac era: ",		z_era)
	
	# parse success
	B2_Sound.play("sn_cc_click_jewel2")
	zodiac_entered.emit()
