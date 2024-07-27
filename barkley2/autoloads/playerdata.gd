extends Node

## CC Data
var paxEnable = 0;

# Events visited #
var event_finished_alignment = false;
var event_finished_crest = false;
var event_finished_cookie = false;
var event_finished_dropdown = false;
var event_finished_inkblots = false;
var event_finished_gumball = false;
var event_finished_handscanner = false;
var event_finished_palmreading = false;
var event_finished_lottery = false;
var event_finished_multiple = false;
var event_finished_stats = false;
var event_finished_tarot = false;

# Character data, default values # These get updated as you go along the CC process #
var character_name = "Bob";
var character_name_type = 0;
var character_race = "Sludge Elf";
var character_class = "Janitor";
var character_zodiac := 1
var character_zodiac_index = 0;
var character_zodiac_year = str("0000");
var character_zodiac_month = 0;
var character_zodiac_day = 0;
var character_zodiac_era = 0;
var character_blood = 0;
var character_gender := [false,false,false,false,false,false]

var character_alignment = 0;
var character_alignment_x := 0;
var character_alignment_y := 0;
var character_moral = 0;		# New variables, original are on the script Quest()
var character_ethical = 0;		# New variables, original are on the script Quest()

var character_crest = false;
var character_crest_data := PackedByteArray()

var character_tarot_cards := [] # New variables, original are on the script Quest()

var character_lottery = false;
var character_gumball = 0;
var character_stats_race = 0;
#for (i=0; i<9; i+=1;) character_dropdown_likes[i] = 0;
#for (i=0; i<7; i+=1;) character_dropdown_favorites[i] = 0;
#for (i=0; i<44; i+=1;) character_multiple[i] = 0;
#for (i=0; i<10; i+=1;) character_palm[i] = 0;
#for (i=0; i<4; i+=1;) character_tarot[i] = 0;

var character_dropdown_likes := Array()
var character_dropdown_favorites := Array()
var character_inkblots := Array()
var character_scanner := Array() ## Hand scanner stats

var character_stat_might = 1;
var character_stat_guts = 1;
var character_stat_acrobatics = 1; 
var character_stat_piety = 1;
var character_stat_luck = 1;

# Pax / COn specific #
#for (i=0; i<4; i+=1;)
	#{
	#character_multiple_QID[i] = 0;
	#character_multiple_AID[i] = 0;
	#}
#character_genders = character_gender[0] + (character_gender[1] * 2) + (character_gender[2] * 4) + (character_gender[3] * 8) + (character_gender[4] * 16);
#pax_code = "0";
#pax_code2 = "0";
#checksum = "0";
#pax_number = 0;
#for (i=0; i<35; i+=1;) pax[i] = "0";
var character_zodiac_year1000 = 0;
var character_zodiac_year100 = 0;
var character_zodiac_year10 = 0;
var character_zodiac_year1 = 0;

## Other shit ##
var placenta_status = -1;
var transition_timer = 25; ## was 14 (bhroom 190529))

func _ready():
	character_inkblots.resize( 16 )
	character_scanner.resize( 10 )
	character_dropdown_likes.resize( 9 )
	character_dropdown_favorites.resize( 7 )

## This func replaces the Quests script.
# /// Quest(name, value?);
# // Quest("myQuest") - Returns value of myQuest
# // Quest("myQuest", 1) - Sets value of myQuest

func quests(key : String, value := ""):
	var questpath = "quest.vars." + key;
	
	if value == "":
		return B2_Config.get_user_save_data(questpath)
	else:
		B2_Config.set_user_save_data(questpath, value)
		return true
