extends Node3D

## check Utility Line 2719 and line 2397 ("draw dna")

const COLORA = B2_Gamedata.c_bio;
const COLORB = B2_Gamedata.c_cyber;
const COLORC = B2_Gamedata.c_cosmic;
const COLORD = B2_Gamedata.c_zauber;

@onready var ball_array := [
	$ball_link21, $ball_link11, $ball_link12, $ball_link13, $ball_link14, $ball_link15, $ball_link16, $ball_link17, $ball_link18, $ball_link19, $ball_link20, $ball_link, $ball_link2, $ball_link3, $ball_link4, $ball_link5, $ball_link6, $ball_link7, $ball_link8, $ball_link9, $ball_link10
]

func _ready() -> void:
	ball_array.make_read_only()
	
func populate_dna() -> void:
	var dnaBio 		= B2_Config.get_user_save_data("player.humanism.bio", 		0); 
	var dnaCyber 	= B2_Config.get_user_save_data("player.humanism.cyber", 	0); 
	var dnaCosmic 	= B2_Config.get_user_save_data("player.humanism.cosmic", 	0); 
	var dnaZauber 	= B2_Config.get_user_save_data("player.humanism.zauber", 	0); 

	var dna_total : int = dnaBio + dnaCyber + dnaCosmic + dnaZauber
	if dna_total != 100:
		print("dna_total different from 100: ", dna_total)
		print_stack()
		
	var ball_array_copy = ball_array.duplicate()
		
	## By default, set all to bio
	for b in ball_array_copy:
		b.change_color( COLORA )
		
	## There are 20 dna "links". 100 "player.humanism" points divided by 5 = 20
	for z in dnaZauber / 5: 
		ball_array_copy.back().change_color( COLORD )
		ball_array_copy.pop_back()
	
	for c in dnaCosmic / 5:
		ball_array_copy.back().change_color( COLORC )
		ball_array_copy.pop_back()
		
	for c in dnaCyber / 5:
		ball_array_copy.back().change_color( COLORB )
		ball_array_copy.pop_back()
