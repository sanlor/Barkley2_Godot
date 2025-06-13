extends Node

## NOTES
# arguments are now different functions
# scr_music_init() included on this autoload

## scr_music_init()
## get duplicate sounds
var debug_messages := false

@warning_ignore("unused_variable")
@onready var tim = Time.get_ticks_msec()

@onready var audio_loop: AudioStreamPlayer = $AudioLoop

## WARNING Modified this code
var souCou = 0
var musCou = 0
var filNam
var dirNam
var pthNam
var sndNam
var sizTot = 0

var soundPlayed := Array()
var soundHealth := Array()

## Godot stuff
@export var audio_folder := "res://barkley2/assets/b2_original/audio/"

var sound_bank := {} ## all sounds that the game has.
var sound_pick := {} ## Allow for multipls sounds for the same effect (Like footsteps having random sounds each step)

var sound_pool 				:= [] ## a whole bunch of AudioStreamPlayer
var sound_pool_amount 		:= 25

var sound_loop				:= {} ## Keep track of the loops

## All SFX files are loaded on an array for easy lookup
func _init_sound_banks():
	# https://gist.github.com/hiulit/772b8784436898fd7f942750ad99e33e
	# https://godotengine.org/asset-library/asset/1974
	## Load audio tracks (SFX)
	var audio_files : Array = FileSearch.search_dir(audio_folder, "", true)
	for file : String in audio_files:
		if file.ends_with(".import"):
			var file_split : Array = file.rsplit("/", false, 1)
			sound_bank[ file_split.back().trim_suffix(".import").replace(".wav","").replace(".ogg","") ] = str( file.trim_suffix(".import") )
	print_rich("[color=medium_purple]Init sound banks ended: ", Time.get_ticks_msec(), " msecs. - ", sound_bank.size(), " sound_bank key entries[/color]")
	
# Im lazy, I just copy/pasted and replaced the invalid strings.
## Copy of the original hack. Enables "nicknames" for sfx files.
func _init_sound_picks():
	#region Madness
	## SEWER STEAM ##
	_add_sound_pick("sewer_steam", "sn_sewer_steam01");
	_add_sound_pick("sewer_steam", "sn_sewer_steam02");
	_add_sound_pick("sewer_steam", "sn_sewer_steam03");

	## HILDEBURGA WRENCH ##
	_add_sound_pick("wrench", "sn_hildeburga_wrench01");
	_add_sound_pick("wrench", "sn_hildeburga_wrench02");
	_add_sound_pick("wrench", "sn_hildeburga_wrench03");

	## PROBOSCIS PICKAXE ##
	_add_sound_pick("proboscis_pickaxe", "sn_proboscisPickaxe01");
	_add_sound_pick("proboscis_pickaxe", "sn_proboscisPickaxe02");
	_add_sound_pick("proboscis_pickaxe", "sn_proboscisPickaxe03");

	## DOJO SLAPS AND GRUNTS ##
	_add_sound_pick("dojo_grunt", "sn_dojogrunt01");
	_add_sound_pick("dojo_grunt", "sn_dojogrunt02");
	_add_sound_pick("dojo_grunt", "sn_dojogrunt03");
	_add_sound_pick("dojo_grunt", "sn_dojogrunt04");
	_add_sound_pick("dojo_slap", "sn_dojoslap01");
	_add_sound_pick("dojo_slap", "sn_dojoslap02");
	_add_sound_pick("dojo_slap", "sn_dojoslap03");
	_add_sound_pick("dojo_slap", "sn_dojoslap04");
	_add_sound_pick("dojo_slap", "sn_dojoslap05");
	_add_sound_pick("dojo_slap", "sn_dojoslap06");

	## FISHING MINIGAME ##
	_add_sound_pick("fishing_lure_cast", "sn_lurecast01");
	_add_sound_pick("fishing_lure_fall", "sn_lurefall01");
	_add_sound_pick("fishing_lure_reel", "sn_fishingreel01");
	_add_sound_pick("fishing_lure_reel_fast", "sn_fishingreelfast01");
	_add_sound_pick("fishing_fish_trashing", "sn_fishtrashing01");
	_add_sound_pick("fishing_fish_trashing", "sn_fishtrashing02");
	_add_sound_pick("fishing_fish_trashing", "sn_fishtrashing03");
	_add_sound_pick("fishing_battle_losing", "sn_fishbattlelosing01");
	_add_sound_pick("fishing_victory", "sn_fishingvictory01");
	_add_sound_pick("fishing_defeat", "sn_fishingdefeat01");
	_add_sound_pick("fishing_fish_hooked", "sn_fishhooked01");

	## SHRUBBERY OF ALL SORTS ##
	_add_sound_pick("shrub", "sn_shrub02");
	_add_sound_pick("shrub", "sn_shrub03");
	_add_sound_pick("shrub", "sn_shrub04");

	## Rubbing against cattails ##
	_add_sound_pick("cattail", "sn_cattail01");
	_add_sound_pick("cattail", "sn_cattail02");
	_add_sound_pick("cattail", "sn_cattail03");
	_add_sound_pick("cattail", "sn_cattail04");

	## Rubbing against tallgrass ##
	_add_sound_pick("tallgrass", "sn_tallgrass01");
	_add_sound_pick("tallgrass", "sn_tallgrass02");
	_add_sound_pick("tallgrass", "sn_tallgrass03");
	_add_sound_pick("tallgrass", "sn_tallgrass04");

	## BUBBLEPOP ##
	_add_sound_pick("bubblepop", "sn_bubblepop01");
	_add_sound_pick("bubblepop", "sn_bubblepop02");
	_add_sound_pick("bubblepop", "sn_bubblepop03");

	## STUPID MINIGAME SHIT AND SUCH ##
	_add_sound_pick("organ_harvest_skin", "sn_pdt_cuttingflesh01");
	_add_sound_pick("organ_harvest_skin", "sn_pdt_cuttingflesh02");
	_add_sound_pick("organ_harvest_skin", "sn_pdt_cuttingflesh03");

	## CREEPYPASTAS ##
	_add_sound_pick("creepypasta_scream", "sn_mg_creepypasta_scream1");
	_add_sound_pick("creepypasta_scream", "sn_mg_creepypasta_scream2");
	_add_sound_pick("creepypasta_scream", "sn_mg_creepypasta_scream3");

	## PUZZLELOCKS ##
	_add_sound_pick("puzzlelock_open", "sn_mg_puzzlelock_open1");
	_add_sound_pick("puzzlelock_open", "sn_mg_puzzlelock_open2");
	_add_sound_pick("puzzlelock_button", "sn_mg_puzzlelock_button1");
	_add_sound_pick("puzzlelock_button", "sn_mg_puzzlelock_button2");
	_add_sound_pick("puzzlelock_button", "sn_mg_puzzlelock_button3");

	## THUNDER SOUUNDS ##
	_add_sound_pick("thunder", "sn_thunder01");
	_add_sound_pick("thunder", "sn_thunder02");
	_add_sound_pick("thunder", "sn_thunder03");
	_add_sound_pick("thunder", "sn_thunder04");
	_add_sound_pick("thunder", "sn_thunder05");
	_add_sound_pick("thunder", "sn_thunder06");
	_add_sound_pick("thunder", "sn_thunder07");
	_add_sound_pick("thunder", "sn_thunder08");
	_add_sound_pick("thunder", "sn_thunder09");
	_add_sound_pick("thunder", "sn_thunder10");
	_add_sound_pick("thunder", "sn_thunder11");
	_add_sound_pick("thunder", "sn_thunder12");
	_add_sound_pick("thunder_muffled", "sn_thunder_muffled01");
	_add_sound_pick("thunder_muffled", "sn_thunder_muffled02");
	_add_sound_pick("thunder_muffled", "sn_thunder_muffled03");
	_add_sound_pick("thunder_muffled", "sn_thunder_muffled04");

	####GENERIC EFFECTS
	## Debris
	_add_sound_pick("debris_clatter", "sn_debris_clatter01");
	_add_sound_pick("debris_clatter", "sn_debris_clatter02");
	_add_sound_pick("debris_clatter", "sn_debris_clatter03");
	_add_sound_pick("debris_clatter", "sn_debris_clatter04");
	_add_sound_pick("debris_clatter", "sn_debris_clatter05");
	_add_sound_pick("debris_clatter", "sn_debris_clatter06");
	_add_sound_pick("debris_clatter", "sn_debris_clatter07");
	_add_sound_pick("debris_clatter", "sn_debris_clatter08");
	_add_sound_pick("debris_clatter", "sn_debris_clatter09");
	_add_sound_pick("debris_clatter", "sn_debris_clatter10");
	_add_sound_pick("debris_clatter", "sn_debris_clatter11");
	_add_sound_pick("debris_clatter", "sn_debris_clatter12");
	_add_sound_pick("debris_clatter", "sn_debris_clatter13");
	_add_sound_pick("debris_clatter", "sn_debris_clatter14");
	_add_sound_pick("debris_clatter", "sn_debris_clatter15");

	#### WEATHER AND ENVIRONMENT ##
	_add_sound_pick("rain_normal", "sn_rain_normal01");
	_add_sound_pick("rain_heavy", "sn_rain_heavy01");
	_add_sound_pick("rain_normal_indoors", "sn_rain_normal_indoors01");
	_add_sound_pick("rain_heavy_indoors", "sn_rain_heavy_indoors01");
	_add_sound_pick("ladder_metal", "sn_metalladder1");
	_add_sound_pick("ladder_metal", "sn_metalladder2");
	_add_sound_pick("ladder_other", "sn_woodladder01");
	_add_sound_pick("ladder_other", "sn_woodladder02");
	_add_sound_pick("ladder_latch", "sn_ladderdrop");
	_add_sound_pick("trailing_steps", "sn_stepstrailing1");
	_add_sound_pick("trailing_steps", "sn_stepstrailing2");
	_add_sound_pick("trailing_steps", "sn_stepstrailing3");

	## DOORS ##
	_add_sound_pick("door_locked", "sn_lock1");
	_add_sound_pick("door_locked", "sn_lock2");
	_add_sound_pick("door_locked", "sn_lock3");
	_add_sound_pick("door_locked", "sn_lock4");
	_add_sound_pick("door_open_tech", "sn_dooropen_tech");
	_add_sound_pick("door_open_sewer", "sn_dooropen_sewer");
	_add_sound_pick("door_open_slab", "sn_dooropen_slab");
	_add_sound_pick("door_open_wood", "sn_dooropen_wood");
	_add_sound_pick("door_open_tnn", "sn_dooropen_tnn");
	_add_sound_pick("door_open_plain", "sn_dooropen_plain");
	_add_sound_pick("door_open_garage", "sn_garagedoor02");
	_add_sound_pick("door_open_garage", "sn_garagedoor03");
	_add_sound_pick("door_close_tech", "sn_doorclosed_tech");
	_add_sound_pick("door_close_sewer", "sn_doorclosed_sewer");
	_add_sound_pick("door_close_slab", "sn_doorclosed_slab");
	_add_sound_pick("door_close_wood", "sn_doorclosed_wood");
	_add_sound_pick("door_close_tnn", "sn_doorclosed_tnn");
	_add_sound_pick("door_close_plain", "sn_doorclosed_plain");
	_add_sound_pick("manhole_opening_closing", "sn_manholecover01");
	_add_sound_pick("manhole_opening_closing", "sn_manholecover02");
	_add_sound_pick("splash_in", "sn_splashobject10");
	_add_sound_pick("splash_out", "sn_splashobject06");

	####HOOPZ SOUNDS
	_add_sound_pick("impact_flaregun", "sn_flaregun_explosion1_1");
	_add_sound_pick("impact_flaregun", "sn_flaregun_explosion1_2");
	_add_sound_pick("impact_flaregun", "sn_flaregun_explosion1_3");

	##_add_sound_pick("hoopz_demise", "sn_hoopz_demiseScream01");
	##_add_sound_pick("hoopz_demise", "sn_hoopz_demiseScream01");
	##_add_sound_pick("hoopz_demise", "sn_hoopz_demiseScream01");

	_add_sound_pick("hoopz_demise", "sn_hoopz_demiseBHROOM01");
	_add_sound_pick("hoopz_demise", "sn_hoopz_demiseERICW01");
	_add_sound_pick("hoopz_demise", "sn_hoopz_demiseLAZ01");

	_add_sound_pick("hoopzweap_pistol3", "sn_pistol3_2");
	_add_sound_pick("hoopzweap_pistol3", "sn_pistol3_4");
	_add_sound_pick("hoopzweap_pistol3", "sn_pistol3_5");

	_add_sound_pick("hoopzweap_flintlock", "sn_flintlock1_1");
	_add_sound_pick("hoopzweap_flintlock", "sn_flintlock1_2");
	_add_sound_pick("hoopzweap_flintlock", "sn_flintlock1_3");

	_add_sound_pick("hoopzweap_flaregun", "sn_flaregun1_1");
	_add_sound_pick("hoopzweap_flaregun", "sn_flaregun1_2");
	_add_sound_pick("hoopzweap_flaregun", "sn_flaregun1_3");

	_add_sound_pick("hoopzweap_revolver", "sn_revolver1_1");
	_add_sound_pick("hoopzweap_revolver", "sn_revolver1_2");
	_add_sound_pick("hoopzweap_revolver", "sn_revolver1_3");

	_add_sound_pick("hoopzweap_magnum", "sn_magnum1_1");
	_add_sound_pick("hoopzweap_magnum", "sn_magnum1_2");
	_add_sound_pick("hoopzweap_magnum", "sn_magnum1_3");

	_add_sound_pick("hoopzweap_pistol6", "sn_pistol6_1");
	_add_sound_pick("hoopzweap_pistol6", "sn_pistol6_2");
	_add_sound_pick("hoopzweap_pistol6", "sn_pistol6_3");

	_add_sound_pick("hoopzweap_rifle", "sn_rifle7_1");
	_add_sound_pick("hoopzweap_rifle", "sn_rifle7_2");
	_add_sound_pick("hoopzweap_rifle", "sn_rifle7_3");

	_add_sound_pick("hoopzweap_musket", "sn_musket1_1");
	_add_sound_pick("hoopzweap_musket", "sn_musket1_2");
	_add_sound_pick("hoopzweap_musket", "sn_musket1_3");

	_add_sound_pick("hoopzweap_sniperrifle", "sn_sniperrifle1_1");
	_add_sound_pick("hoopzweap_sniperrifle", "sn_sniperrifle1_2");
	_add_sound_pick("hoopzweap_sniperrifle", "sn_sniperrifle1_3");

	_add_sound_pick("hoopzweap_huntingrifle", "sn_huntingrifle9_1");
	_add_sound_pick("hoopzweap_huntingrifle", "sn_huntingrifle9_2");
	_add_sound_pick("hoopzweap_huntingrifle", "sn_huntingrifle9_3");

	_add_sound_pick("hoopzweap_tranqrifle", "sn_tranqrifle1_1");
	_add_sound_pick("hoopzweap_tranqrifle", "sn_tranqrifle1_2");
	_add_sound_pick("hoopzweap_tranqrifle", "sn_tranqrifle1_3");

	_add_sound_pick("hoopzweap_shotgun", "sn_shotgun5");
	_add_sound_pick("hoopzweap_shotgun", "sn_shotgun6");
	_add_sound_pick("hoopzweap_shotgun", "sn_shotgun9");

	_add_sound_pick("hoopzweap_doublebarreledshotgun", "sn_doublebarreledshotgun1_1");
	_add_sound_pick("hoopzweap_doublebarreledshotgun", "sn_doublebarreledshotgun1_2");
	_add_sound_pick("hoopzweap_doublebarreledshotgun", "sn_doublebarreledshotgun1_3");

	_add_sound_pick("hoopzweap_revolvershotgun", "sn_revolvershotgun1_1");
	_add_sound_pick("hoopzweap_revolvershotgun", "sn_revolvershotgun1_2");
	_add_sound_pick("hoopzweap_revolvershotgun", "sn_revolvershotgun1_3");

	_add_sound_pick("hoopzweap_elephantgun", "sn_elephantgun1_1");
	_add_sound_pick("hoopzweap_elephantgun", "sn_elephantgun1_2");
	_add_sound_pick("hoopzweap_elephantgun", "sn_elephantgun1_3");

	_add_sound_pick("hoopzweap_smg", "sn_smg3_1");
	_add_sound_pick("hoopzweap_smg", "sn_smg3_2");
	_add_sound_pick("hoopzweap_smg", "sn_smg3_3");

	_add_sound_pick("hoopzweap_hmg", "sn_hmg1_1");
	_add_sound_pick("hoopzweap_hmg", "sn_hmg1_2");
	_add_sound_pick("hoopzweap_hmg", "sn_hmg1_3");

	_add_sound_pick("hoopzweap_assaultrifle", "sn_assaultrifle1_1");
	_add_sound_pick("hoopzweap_assaultrifle", "sn_assaultrifle1_2");
	_add_sound_pick("hoopzweap_assaultrifle", "sn_assaultrifle1_3");

	_add_sound_pick("hoopzweap_crossbow", "sn_crossbow1_1");
	_add_sound_pick("hoopzweap_crossbow", "sn_crossbow1_2");
	_add_sound_pick("hoopzweap_crossbow", "sn_crossbow1_3");

	_add_sound_pick("hoopzweap_flamethrower_trigger", "sn_flamethrower_click03");
	_add_sound_pick("hoopzweap_flamethrower_gas", "sn_flamethrower_gas03");

	_add_sound_pick("hoopzweap_flamethrower_attack", "sn_flamethrower_attack03");
	_add_sound_pick("hoopzweap_flamethrower_sustain", "sn_flamethrower_sustain03");
	_add_sound_pick("hoopzweap_flamethrower_release", "sn_flamethrower_release03");

	_add_sound_pick("hoopzweap_minigun", "sn_minigun3");
	_add_sound_pick("hoopzweap_minigun", "sn_minigun7");
	_add_sound_pick("hoopzweap_minigun", "sn_minigun8");
	_add_sound_pick("hoopzweap_minig_windup", "sn_windup01");
	_add_sound_pick("hoopzweap_minig_windup", "sn_windup02");
	_add_sound_pick("hoopzweap_minig_windup", "sn_windup04");
	_add_sound_pick("hoopzweap_minig_windup", "sn_windup06");

	_add_sound_pick("hoopzweap_minig_sustain", "sn_sustain01");
	_add_sound_pick("hoopzweap_minig_sustain", "sn_sustain02");
	_add_sound_pick("hoopzweap_minig_sustain", "sn_sustain04");
	_add_sound_pick("hoopzweap_minig_sustain", "sn_sustain06");

	_add_sound_pick("hoopzweap_minig_winddown", "sn_winddown01");
	_add_sound_pick("hoopzweap_minig_winddown", "sn_winddown04");
	_add_sound_pick("hoopzweap_minig_winddown", "sn_winddown02");
	_add_sound_pick("hoopzweap_minig_winddown", "sn_winddown06");

	##Hit sounds
	_add_sound_pick("hoopzDmgSoundNormal", "sn_hoopzDmgSoundNormal01");
	_add_sound_pick("hoopzDmgSoundNormal", "sn_hoopzDmgSoundNormal02");
	_add_sound_pick("hoopzDmgSoundNormal", "sn_hoopzDmgSoundNormal03");
	_add_sound_pick("hoopzDmgSoundNormalKb", "sn_hoopzDmgSoundNormalKB01");
	_add_sound_pick("hoopzDmgSoundNormalKb", "sn_hoopzDmgSoundNormalKB02");
	_add_sound_pick("hoopzDmgSoundNormalKb", "sn_hoopzDmgSoundNormalKB03");

	_add_sound_pick("hoopzDmgSoundBio", "sn_debug_one");
	_add_sound_pick("hoopzDmgSoundBioKb", "sn_debug_two");

	_add_sound_pick("hoopzDmgSoundCyber", "sn_debug_one");
	_add_sound_pick("hoopzDmgSoundCyberKb", "sn_debug_two");

	_add_sound_pick("hoopzDmgSoundMental", "sn_debug_one");
	_add_sound_pick("hoopzDmgSoundMentalKb", "sn_debug_two");

	_add_sound_pick("hoopzDmgSoundCosmic", "sn_debug_one");
	_add_sound_pick("hoopzDmgSoundCosmicKb", "sn_debug_two");

	_add_sound_pick("hoopzDmgSoundZauber", "sn_debug_one");
	_add_sound_pick("hoopzDmgSoundZauberKb", "sn_debug_two");

	####/Special material sounds

	## Candy Gun's Brast ##
	_add_sound_pick("candy_shot", "sn_bubblepop01");
	_add_sound_pick("candy_shot", "sn_bubblepop02");
	_add_sound_pick("candy_shot", "sn_bubblepop03");

	## Candy Gun's Debris ## This is the debris that scatters after bullet impact ##
	_add_sound_pick("candy_impact", "sn_bonedebris01");
	_add_sound_pick("candy_impact", "sn_bonedebris02");
	_add_sound_pick("candy_impact", "sn_bonedebris03");
	_add_sound_pick("candy_impact", "sn_bonedebris04");

	## 3D Printed ##

	## Soiled Gun's Brast ##
	_add_sound_pick("hoopzweap_soiled_shot", "sn_rottengunfire01");
	_add_sound_pick("hoopzweap_soiled_shot", "sn_rottengunfire02");
	_add_sound_pick("hoopzweap_soiled_shot", "sn_rottengunfire03");

	## Rotten Gun's Brast ##
	_add_sound_pick("hoopzweap_rotten_shot", "sn_rottengunfire01");
	_add_sound_pick("hoopzweap_rotten_shot", "sn_rottengunfire02");
	_add_sound_pick("hoopzweap_rotten_shot", "sn_rottengunfire03");

	## Rotten Gun's Impact ##
	_add_sound_pick("hoopzweap_rotten_impact", "sn_rottengunimpact01");
	_add_sound_pick("hoopzweap_rotten_impact", "sn_rottengunimpact02");
	_add_sound_pick("hoopzweap_rotten_impact", "sn_rottengunimpact03");

	## Broken Gun's Brast ##
	_add_sound_pick("hoopzweap_broken_shot", "sn_brokengunfire01");
	_add_sound_pick("hoopzweap_broken_shot", "sn_brokengunfire02");
	_add_sound_pick("hoopzweap_broken_shot", "sn_brokengunfire03");

	## Broken Gun's Misfire ##
	_add_sound_pick("hoopzweap_broken_misfire", "sn_brokengunmissfire01");

	## Broken Gun's Wide Shot ##
	_add_sound_pick("hoopzweap_broken_wideshot", "sn_brokengunwideshot01");
	_add_sound_pick("hoopzweap_broken_wideshot", "sn_brokengunwideshot02");
	_add_sound_pick("hoopzweap_broken_wideshot", "sn_brokengunwideshot03");

	## Carbon ##

	## Mythril ##

	## Rusty ##

	## Junk Gun's Brast ##
	_add_sound_pick("hoopzweap_junk_shot", "sn_junkgunfire01");
	_add_sound_pick("hoopzweap_junk_shot", "sn_junkgunfire02");
	_add_sound_pick("hoopzweap_junk_shot", "sn_junkgunfire03");

	## Junk Gun's Impact ##
	_add_sound_pick("hoopzweap_junk_impact", "sn_junkgunimpact01");
	_add_sound_pick("hoopzweap_junk_impact", "sn_junkgunimpact02");
	_add_sound_pick("hoopzweap_junk_impact", "sn_junkgunimpact03");

	## Junk Gun's Debris ## This is the debris that scatters after bullet impact ##
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris01");
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris02");
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris03");
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris04");
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris05");
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris06");
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris07");
	_add_sound_pick("hoopzweap_junk_debris", "sn_junkgundebris08");

	## Neon Gun's Brast ##
	_add_sound_pick("hoopzweap_neon_shot", "sn_neonshot01");
	_add_sound_pick("hoopzweap_neon_shot", "sn_neonshot01");
	_add_sound_pick("hoopzweap_neon_shot", "sn_neonshot01");

	## Salt Gun's Brast ##
	_add_sound_pick("hoopzweap_salt_shot", "sn_saltshot01");
	_add_sound_pick("hoopzweap_salt_shot", "sn_saltshot02");
	_add_sound_pick("hoopzweap_salt_shot", "sn_saltshot03");

	## Salt Gun's Impact ##
	_add_sound_pick("hoopzweap_salt_impact", "sn_saltimpact01");
	_add_sound_pick("hoopzweap_salt_impact", "sn_saltimpact02");
	_add_sound_pick("hoopzweap_salt_impact", "sn_saltimpact03");

	## Wood ##

	## Aluminum ##

	## Glass Gun's Brast ##
	_add_sound_pick("hoopzweap_glass_shot", "sn_glassfire01");
	_add_sound_pick("hoopzweap_glass_shot", "sn_glassfire02");
	_add_sound_pick("hoopzweap_glass_shot", "sn_glassfire03");

	## Glass Gun's Impact ##
	_add_sound_pick("hoopzweap_glass_impact", "sn_glassbreak01");
	_add_sound_pick("hoopzweap_glass_impact", "sn_glassbreak02");
	_add_sound_pick("hoopzweap_glass_impact", "sn_glassbreak03");

	## Plastic Foam Dart Gun's Brast ##
	_add_sound_pick("hoopzweap_foamdart_shot", "sn_dartgunfire01");
	_add_sound_pick("hoopzweap_foamdart_shot", "sn_dartgunfire02");
	_add_sound_pick("hoopzweap_foamdart_shot", "sn_dartgunfire03");

	## Plastic Foam Dart Gun's Impact ##
	_add_sound_pick("hoopzweap_foamdart_impact", "sn_dartgunimpact01");
	_add_sound_pick("hoopzweap_foamdart_impact", "sn_dartgunimpact02");
	_add_sound_pick("hoopzweap_foamdart_impact", "sn_dartgunimpact03");

	## Leather ##

	## Studded ##

	## Dual ##

	## Plantain Gun's Brast ##
	_add_sound_pick("hoopzweap_plantain_shot", "sn_plantanshot01");
	_add_sound_pick("hoopzweap_plantain_shot", "sn_plantanshot02");
	_add_sound_pick("hoopzweap_plantain_shot", "sn_plantanshot03");

	## Plantain Gun's Impact ##
	_add_sound_pick("hoopzweap_plantain_impact", "sn_plantanhit01");
	_add_sound_pick("hoopzweap_plantain_impact", "sn_plantanhit02");
	_add_sound_pick("hoopzweap_plantain_impact", "sn_plantanhit03");

	## Plantain Gun's Slip ## Slip on a banana peel ##
	_add_sound_pick("hoopzweap_plantain_slip", "sn_plantanslip01");
	_add_sound_pick("hoopzweap_plantain_slip", "sn_plantanslip02");
	_add_sound_pick("hoopzweap_plantain_slip", "sn_plantanslip03");

	## Plantain Gun's Spawn ## Spawn some banana peels ##
	_add_sound_pick("hoopzweap_plantain_spawn", "sn_plantanspawn01");
	_add_sound_pick("hoopzweap_plantain_spawn", "sn_plantanspawn02");
	_add_sound_pick("hoopzweap_plantain_spawn", "sn_plantanspawn03");

	## Bone Gun's Brast ##
	_add_sound_pick("hoopzweap_bone_shot", "sn_bonegunfire01");
	_add_sound_pick("hoopzweap_bone_shot", "sn_bonegunfire02");
	_add_sound_pick("hoopzweap_bone_shot", "sn_bonegunfire03");

	## Bone Gun's Impact ##
	_add_sound_pick("hoopzweap_bone_impact", "sn_bonegunimpact01");
	_add_sound_pick("hoopzweap_bone_impact", "sn_bonegunimpact02");
	_add_sound_pick("hoopzweap_bone_impact", "sn_bonegunimpact03");

	## Bone Gun's Debris ## This is the debris that scatters after bullet impact ##
	_add_sound_pick("hoopzweap_bone_debris", "sn_bonedebris01");
	_add_sound_pick("hoopzweap_bone_debris", "sn_bonedebris02");
	_add_sound_pick("hoopzweap_bone_debris", "sn_bonedebris03");
	_add_sound_pick("hoopzweap_bone_debris", "sn_bonedebris04");

	## Aluminium ##

	## Titanium ##

	## Stone Gun's Brast ##
	_add_sound_pick("hoopzweap_stone_shot", "sn_stonegunfire01");
	_add_sound_pick("hoopzweap_stone_shot", "sn_stonegunfire02");
	_add_sound_pick("hoopzweap_stone_shot", "sn_stonegunfire03");

	## Stone Gun's Impact ##
	_add_sound_pick("hoopzweap_stone_impact", "sn_stonegunimpact01");
	_add_sound_pick("hoopzweap_stone_impact", "sn_stonegunimpact02");
	_add_sound_pick("hoopzweap_stone_impact", "sn_stonegunimpact03");

	## Stone Gun's Moai Head ## BFG ##
	_add_sound_pick("hoopzweap_stone_moai", "sn_stonemoai");

	## Chrome ##

	## Frankincense ##

	## Iron ##

	## Cobalt ##

	## Nickel ##

	## Copper ##

	## Zinc ##

	## Fiberglass ##

	## Grass Gun's Shot ##
	_add_sound_pick("hoopzweap_grass_shot", "sn_grassshot01");
	_add_sound_pick("hoopzweap_grass_shot", "sn_grassshot02");
	_add_sound_pick("hoopzweap_grass_shot", "sn_grassshot03");

	## Soy ##
	_add_sound_pick("hoopzweap_soy_shot", "sn_soygunfire01");
	_add_sound_pick("hoopzweap_soy_shot", "sn_soygunfire02");
	_add_sound_pick("hoopzweap_soy_shot", "sn_soygunfire03");

	## Steel ##

	## Brass ##

	## Orichalcum Gun's Brast ##
	_add_sound_pick("hoopzweap_orichalcum_shot", "sn_orchihaliumshot01");
	_add_sound_pick("hoopzweap_orichalcum_shot", "sn_orchihaliumshot02");
	_add_sound_pick("hoopzweap_orichalcum_shot", "sn_orchihaliumshot03");

	## Orichalcum Gun's Bounce ##
	_add_sound_pick("hoopzweap_orichalcum_bounce", "sn_orchihaliumbounce01");
	_add_sound_pick("hoopzweap_orichalcum_bounce", "sn_orchihaliumbounce02");
	_add_sound_pick("hoopzweap_orichalcum_bounce", "sn_orchihaliumbounce03");

	## Napalm Gun's Brast ##
	_add_sound_pick("hoopzweap_napalm_shot", "sn_napalmshot01");
	_add_sound_pick("hoopzweap_napalm_shot", "sn_napalmshot02");
	_add_sound_pick("hoopzweap_napalm_shot", "sn_napalmshot03");

	## Napalm Gun's Brast ## Alternative ##
	_add_sound_pick("hoopzweap_napalm_shot_alt", "sn_napalmshotvariant01");
	_add_sound_pick("hoopzweap_napalm_shot_alt", "sn_napalmshotvariant02");
	_add_sound_pick("hoopzweap_napalm_shot_alt", "sn_napalmshotvariant03");

	## Origami Gun's Brast ##
	_add_sound_pick("hoopzweap_origami_shot", "sn_oragamishot01");
	_add_sound_pick("hoopzweap_origami_shot", "sn_oragamishot02");
	_add_sound_pick("hoopzweap_origami_shot", "sn_oragamishot03");

	## Origami Gun's Impact ##
	_add_sound_pick("hoopzweap_origami_impact", "sn_oragamihit01");
	_add_sound_pick("hoopzweap_origami_impact", "sn_oragamihit02");
	_add_sound_pick("hoopzweap_origami_impact", "sn_oragamihit03");

	## Origami Gun's Flight ##
	_add_sound_pick("hoopzweap_origami_fly", "sn_oragamifly01");
	_add_sound_pick("hoopzweap_origami_fly", "sn_oragamifly02");
	_add_sound_pick("hoopzweap_origami_fly", "sn_oragamifly03");

	## Offal Gun's Brast ##
	_add_sound_pick("hoopzweap_offal_shot", "sn_offalshot01");
	_add_sound_pick("hoopzweap_offal_shot", "sn_offalshot02");
	_add_sound_pick("hoopzweap_offal_shot", "sn_offalshot03");

	## Crystal Gun's Brast ##
	_add_sound_pick("hoopzweap_crystal_shot", "sn_crystalshot01");
	_add_sound_pick("hoopzweap_crystal_shot", "sn_crystalshot02");
	_add_sound_pick("hoopzweap_crystal_shot", "sn_crystalshot03");

	## Crystal Gun's Brast ## Alternative ##
	_add_sound_pick("hoopzweap_crystal_shot_alt", "sn_crystalshotvariant01");
	_add_sound_pick("hoopzweap_crystal_shot_alt", "sn_crystalshotvariant02");
	_add_sound_pick("hoopzweap_crystal_shot_alt", "sn_crystalshotvariant03");

	## Crystal Gun's Impact Explosion ##
	_add_sound_pick("hoopzweap_crystal_explode", "sn_crystalexplosion01");
	_add_sound_pick("hoopzweap_crystal_explode", "sn_crystalexplosion02");
	_add_sound_pick("hoopzweap_crystal_explode", "sn_crystalexplosion03");

	## Crystal Gun's Brast ## Alternative ##
	_add_sound_pick("hoopzweap_crystal_bullet", "sn_crystalbullet01");
	_add_sound_pick("hoopzweap_crystal_bullet", "sn_crystalbullet02");
	_add_sound_pick("hoopzweap_crystal_bullet", "sn_crystalbullet03");

	## Adamantium Gun's Brast ##
	_add_sound_pick("hoopzweap_adamantium_shot", "sn_adamantiumshot01");
	_add_sound_pick("hoopzweap_adamantium_shot", "sn_adamantiumshot02");
	_add_sound_pick("hoopzweap_adamantium_shot", "sn_adamantiumshot03");

	## Silk Gun's Brast ##
	_add_sound_pick("hoopzweap_silk_shot", "sn_silkshot01");
	_add_sound_pick("hoopzweap_silk_shot", "sn_silkshot02");
	_add_sound_pick("hoopzweap_silk_shot", "sn_silkshot03");

	## Silk Gun's Impact ##
	_add_sound_pick("hoopzweap_silk_impact", "sn_silkimpact01");
	_add_sound_pick("hoopzweap_silk_impact", "sn_silkimpact02");
	_add_sound_pick("hoopzweap_silk_impact", "sn_silkimpact03");

	## Marble Gun's Shot ##
	_add_sound_pick("hoopzweap_marble_shot", "sn_marbleshot01");
	_add_sound_pick("hoopzweap_marble_shot", "sn_marbleshot02");
	_add_sound_pick("hoopzweap_marble_shot", "sn_marbleshot03");

	## Marble Gun's Shot ## Alternative ##
	_add_sound_pick("hoopzweap_marble_shot_alt", "sn_marbleshotvariant01");
	_add_sound_pick("hoopzweap_marble_shot_alt", "sn_marbleshotvariant02");
	_add_sound_pick("hoopzweap_marble_shot_alt", "sn_marbleshotvariant03");

	## Rubber Gun's Brast ##
	_add_sound_pick("hoopzweap_rubber_shot", "sn_rubbergunshot01");
	_add_sound_pick("hoopzweap_rubber_shot", "sn_rubbergunshot02");
	_add_sound_pick("hoopzweap_rubber_shot", "sn_rubbergunshot03");

	## Rubber Bounce ##
	_add_sound_pick("hoopzweap_rubber_bounce", "sn_rubberbounce01");
	_add_sound_pick("hoopzweap_rubber_bounce", "sn_rubberbounce02");
	_add_sound_pick("hoopzweap_rubber_bounce", "sn_rubberbounce03");

	## Foil Gun's Brast ##
	_add_sound_pick("hoopzweap_foil_shot", "sn_foilgun01");
	_add_sound_pick("hoopzweap_foil_shot", "sn_foilgun02");
	_add_sound_pick("hoopzweap_foil_shot", "sn_foilgun03");

	## Blood ##

	## Silver ##

	## Chitin Gun's Brast ##
	_add_sound_pick("hoopzweap_chitin_shot", "sn_chitlinshot01");
	_add_sound_pick("hoopzweap_chitin_shot", "sn_chitlinshot02");
	_add_sound_pick("hoopzweap_chitin_shot", "sn_chitlinshot03");

	## Chitin Gun's Egg Hatch ##
	_add_sound_pick("hoopzweap_chitin_hatch", "sn_chitlinhatch01");
	_add_sound_pick("hoopzweap_chitin_hatch", "sn_chitlinhatch02");
	_add_sound_pick("hoopzweap_chitin_hatch", "sn_chitlinhatch03");

	## Chitin Gun's Critter Jump ##
	_add_sound_pick("hoopzweap_chitin_jump", "sn_chitlinjump01");
	_add_sound_pick("hoopzweap_chitin_jump", "sn_chitlinjump02");
	_add_sound_pick("hoopzweap_chitin_jump", "sn_chitlinjump03");

	## Chitin Gun's Debris ## This is the debris that scatters after bullet impact ##
	_add_sound_pick("hoopzweap_chitin_die", "sn_chitlindebris01");
	_add_sound_pick("hoopzweap_chitin_die", "sn_chitlindebris02");
	_add_sound_pick("hoopzweap_chitin_die", "sn_chitlindebris03");

	## Sinew ##

	## Tin ##

	## Obsidian ##

	## Fungus Gun's Brast ## 
	_add_sound_pick("fungi_spore_shot", "sn_fungusgunshot01"); 
	_add_sound_pick("fungi_spore_shot", "sn_fungusgunshot02"); 
	_add_sound_pick("fungi_spore_shot", "sn_fungusgunshot03");

	## Fungus Gun's Growth ## Shrooms grow out of the pollen ##
	_add_sound_pick("fungi_spore_grow_mushroom", "sn_fungusgrowth01");
	_add_sound_pick("fungi_spore_grow_mushroom", "sn_fungusgrowth02");
	_add_sound_pick("fungi_spore_grow_mushroom", "sn_fungusgrowth03");
	_add_sound_pick("fungi_spore_grow_mushroom", "sn_fungusgrowth04");

	## Damascus ##

	## Analog ##

	## Digital Gun's Brast ##
	_add_sound_pick("digital_shot", "sn_digitalshot01");
	_add_sound_pick("digital_shot", "sn_digitalshot02");
	_add_sound_pick("digital_shot", "sn_digitalshot03");

	## Digital Gun's Impact ##
	_add_sound_pick("digital_impact", "sn_digitalhit01");
	_add_sound_pick("digital_impact", "sn_digitalhit02");
	_add_sound_pick("digital_impact", "sn_digitalhit03");

	## Brain ##

	## Chobham ##

	## Bronze ##

	## Blaster Gun's Brast ##
	_add_sound_pick("hoopzweap_blaster_shot", "sn_blastershot01");
	_add_sound_pick("hoopzweap_blaster_shot", "sn_blastershot02");
	_add_sound_pick("hoopzweap_blaster_shot", "sn_blastershot03");

	## Blaster Gun's Brast Alternative ##
	_add_sound_pick("hoopzweap_blaster_shot", "sn_blastershotvar01");
	_add_sound_pick("hoopzweap_blaster_shot", "sn_blastershotvar02");
	_add_sound_pick("hoopzweap_blaster_shot", "sn_blastershotvar03");
	
	## Blaster Gun's Brast ## - NOTE: BHROOM SWAPPED THE IMPACT AND SHOT SOUNDS, BUT DIDN'T RENAME THEM AS OF 9-27-2018
	#_add_sound_pick("hoopzweap_blaster_shot", "sn_blasterimpact01");
	#_add_sound_pick("hoopzweap_blaster_shot", "sn_blasterimpact02");
	#_add_sound_pick("hoopzweap_blaster_shot", "sn_blasterimpact03");

	## Blaster Gun's Impact ## - NOTE: BHROOM SWAPPED THE IMPACT AND SHOT SOUNDS, BUT DIDN'T RENAME THEM AS OF 9-27-2018
	#_add_sound_pick("hoopzweap_blaster_impact", "sn_blastershot01");
	#_add_sound_pick("hoopzweap_blaster_impact", "sn_blastershot02");
#	_add_sound_pick("hoopzweap_blaster_impact", "sn_blastershot03");

	## Tungsten ##

	## Itano Rocket Sounds
	_add_sound_pick("hoopzweap_itano_minirocket", "sn_minirocketattack01");  ##/machinegun-like rocket launchers
	_add_sound_pick("hoopzweap_itano_smallrocket", "sn_smallrocketattack01"); ##/smaller rockets
	_add_sound_pick("hoopzweap_itano_bigrocket", "sn_largerocketattack01");  ##/for big rocket launchers

	## Pearl Gun's Brast ##
	_add_sound_pick("hoopzweap_pearl_shot", "sn_pearlgunshot01");
	_add_sound_pick("hoopzweap_pearl_shot", "sn_pearlgunshot02");
	_add_sound_pick("hoopzweap_pearl_shot", "sn_pearlgunshot03");

	## Pearl Gun's Trail ##
	_add_sound_pick("hoopzweap_pearl_trail", "sn_pearlguntrail01");
	_add_sound_pick("hoopzweap_pearl_trail", "sn_pearlguntrail02");
	_add_sound_pick("hoopzweap_pearl_trail", "sn_pearlguntrail03");

	## Pearl Gun's Brast Alternative ##
	_add_sound_pick("hoopzweap_pearl_shot_alt", "sn_pearlgunvar01");
	_add_sound_pick("hoopzweap_pearl_shot_alt", "sn_pearlgunvar02");
	_add_sound_pick("hoopzweap_pearl_shot_alt", "sn_pearlgunvar03");

	## Myrrh ##

	## Platinum ##

	## Gold ##

	## Mercury ##

	## Imaginary Gun's Brasting ##
	##TODO: this bank of "Imaginary" sounds have debug and need actual sounds
	_add_sound_pick("hoopzweap_imaginary_pistol", "sn_debug_three");
	_add_sound_pick("hoopzweap_imaginary_shotgun", "sn_debug_four");
	_add_sound_pick("hoopzweap_imaginary_tranquilizer", "sn_debug_six");
	_add_sound_pick("hoopzweap_imaginary_flamethrower", "sn_debug_seven");
	_add_sound_pick("hoopzweap_imaginary_crossbow", "sn_debug_eight");

	_add_sound_pick("hoopzweap_imaginary_bfg_chargeup", "sn_imaginaryBFGchargeup01");
	_add_sound_pick("hoopzweap_imaginary_bfg_chargeup", "sn_imaginaryBFGchargeup02");
	_add_sound_pick("hoopzweap_imaginary_bfg_chargeup", "sn_imaginaryBFGchargeup03");

	_add_sound_pick("hoopzweap_imaginary_bfg_shot", "sn_imaginaryBFGshot01");
	_add_sound_pick("hoopzweap_imaginary_bfg_shot", "sn_imaginaryBFGshot02");
	_add_sound_pick("hoopzweap_imaginary_bfg_shot", "sn_imaginaryBFGshot03");

	_add_sound_pick("hoopzweap_imaginary_bfg_explosion_large", "sn_imaginaryexplosionlarge01");
	_add_sound_pick("hoopzweap_imaginary_bfg_explosion_large", "sn_imaginaryexplosionlarge02");
	_add_sound_pick("hoopzweap_imaginary_bfg_explosion_large", "sn_imaginaryexplosionlarge03");

	_add_sound_pick("hoopzweap_imaginary_bfg_explosion_small", "sn_imaginaryexplosionsmall01");
	_add_sound_pick("hoopzweap_imaginary_bfg_explosion_small", "sn_imaginaryexplosionsmall02");
	_add_sound_pick("hoopzweap_imaginary_bfg_explosion_small", "sn_imaginaryexplosionsmall03");

	_add_sound_pick("hoopzweap_imaginary_gatling_gun", "sn_imaginarygatlingun01");
	_add_sound_pick("hoopzweap_imaginary_gatling_gun", "sn_imaginarygatlingun02");
	_add_sound_pick("hoopzweap_imaginary_gatling_gun", "sn_imaginarygatlingun03");

	_add_sound_pick("hoopzweap_imaginary_machine_gun", "sn_imaginarymachinegun01");
	_add_sound_pick("hoopzweap_imaginary_machine_gun", "sn_imaginarymachinegun02");
	_add_sound_pick("hoopzweap_imaginary_machine_gun", "sn_imaginarymachinegun03");

	_add_sound_pick("hoopzweap_imaginary_rocket", "sn_imaginaryrocketshot01");
	_add_sound_pick("hoopzweap_imaginary_rocket", "sn_imaginaryrocketshot02");
	_add_sound_pick("hoopzweap_imaginary_rocket", "sn_imaginaryrocketshot03");

	_add_sound_pick("hoopzweap_imaginary_winddown", "sn_imaginarywinddown01");
	_add_sound_pick("hoopzweap_imaginary_windsustain", "sn_imaginarywindsustain01");
	_add_sound_pick("hoopzweap_imaginary_windup", "sn_imaginarywindup01");

	## Lead ##

	## Diamond ##

	## Polenta ##

	## Yggdrasil ##

	## Pinata Gun's Brast ##
	_add_sound_pick("hoopzweap_pinata_shot", "sn_pinatashotsmall01");
	_add_sound_pick("hoopzweap_pinata_shot", "sn_pinatashotsmall02");
	_add_sound_pick("hoopzweap_pinata_shot", "sn_pinatashotsmall03");

	## Pinata Gun's Brast Large ##
	_add_sound_pick("hoopzweap_pinata_shot_large", "sn_pinatashotlarge01");
	_add_sound_pick("hoopzweap_pinata_shot_large", "sn_pinatashotlarge02");
	_add_sound_pick("hoopzweap_pinata_shot_large", "sn_pinatashotlarge03");

	## Francium Gun's Brast ##
	_add_sound_pick("hoopzweap_francium_shot", "sn_franciumshot01"); 
	_add_sound_pick("hoopzweap_francium_shot", "sn_franciumshot02"); 
	_add_sound_pick("hoopzweap_francium_shot", "sn_franciumshot03");

	## Francium Gun's Orb sound ## The Orb emits a looping sort of sound ##
	_add_sound_pick("hoopzweap_francium_hum", "sn_franciumorbloop01"); 
	_add_sound_pick("hoopzweap_francium_hum", "sn_franciumorbloop02");

	## Orb ##

	## Nanotube ##

	## Taxidermy ##

	## Porcelain ##

	## Antimatter Gun's Brast ##
	_add_sound_pick("hoopzweap_antimatter_shot", "sn_antimattergun01"); 
	_add_sound_pick("hoopzweap_antimatter_shot", "sn_antimattergun02");
	_add_sound_pick("hoopzweap_antimatter_shot", "sn_antimattergun03");

	## Antimatter Gun's Brast ## Alternative ##
	_add_sound_pick("hoopzweap_antimatter_rapidshot", "sn_antimattergunvariant01");  
	_add_sound_pick("hoopzweap_antimatter_rapidshot", "sn_antimattergunvariant02");
	_add_sound_pick("hoopzweap_antimatter_rapidshot", "sn_antimattergunvariant03");

	## Aerogel ##

	## Denim ##

	## Untamonium ##
	_add_sound_pick("untamonium_shot", "sn_untamoniumShot01");
	_add_sound_pick("untamonium_shot", "sn_untamoniumShot02");
	_add_sound_pick("untamonium_shot", "sn_untamoniumShot03");
	_add_sound_pick("untamonium_shot", "sn_untamoniumShot04");




	## BFG Shots ## Delay before the shot ## Windup ##
	_add_sound_pick("hoopzweap_BFG_charge", "sn_bfgchargeup01");  
	_add_sound_pick("hoopzweap_BFG_charge", "sn_bfgchargeup02");
	_add_sound_pick("hoopzweap_BFG_charge", "sn_bfgchargeup03");

	## BFG Shots ## The Brast itself ##
	_add_sound_pick("hoopzweap_BFG_shot", "sn_bfgshot01");
	_add_sound_pick("hoopzweap_BFG_shot", "sn_bfgshot02");
	_add_sound_pick("hoopzweap_BFG_shot", "sn_bfgshot03");

	## BFG Shots ## Impact ##
	_add_sound_pick("hoopzweap_BFG_explode", "sn_bfgexplode01");
	_add_sound_pick("hoopzweap_BFG_explode", "sn_bfgexplode02");
	_add_sound_pick("hoopzweap_BFG_explode", "sn_bfgexplode03");

	## Rocket Launcher Sounds
	_add_sound_pick("hoopzweap_rocket_shot", "sn_rocketshot01");  ##/ Exhaust sound while Rocket Launcher rocket is travelling
	_add_sound_pick("hoopzweap_rocket_exhaust", "sn_rocketexhaust01");  ##/ Exhaust sound while Itano or Rocket Launcher rocket is travelling
	_add_sound_pick("hoopzweap_rocket_impact", "sn_rocketimpact01");  ##/ Explosion for rocket launcher

	## Footsteps Normal ##
	_add_sound_pick("hoopz_footstep", "sn_hoopz_footL2");
	_add_sound_pick("hoopz_footstep", "sn_hoopz_footR2");

	## Footsteps while inside Oligarchy Online ##
	_add_sound_pick("hoopz_footstep_vrw", "sn_footstep_vrw_00");
	_add_sound_pick("hoopz_footstep_vrw", "sn_footstep_vrw_01");
	_add_sound_pick("hoopz_footstep_vrw", "sn_footstep_vrw_02");

	## Footsteps while wading in water ##
	_add_sound_pick("hoopz_wadestep", "sn_hoopz_waterstep01");
	_add_sound_pick("hoopz_wadestep", "sn_hoopz_waterstep02");

	## Footsteps while walking in a rain puddle ##
	_add_sound_pick("hoopz_puddlestep", "sn_puddlestep01");
	_add_sound_pick("hoopz_puddlestep", "sn_puddlestep02");

	## Hoopz dodge roll ##
	_add_sound_pick("hoopz_dash_leap", "sn_hoopz_roll");

	## Candy crunching ##
	_add_sound_pick("hoopz_crunchcandy", "sn_hoopz_candy04");
	_add_sound_pick("hoopz_crunchcandy", "sn_hoopz_candy05");
	_add_sound_pick("hoopz_crunchcandy", "sn_hoopz_candy06");

	_add_sound_pick("hoopz_reload", "sn_shotgun_reload01");
	_add_sound_pick("hoopz_reload", "sn_shotgun_reload02");
	_add_sound_pick("hoopz_reload", "sn_shotgun_reload03");
	## NOTE maybe missing reload sfx?
	
	_add_sound_pick("hoopz_pistol_reload", "sn_gun_reload10");
	_add_sound_pick("hoopz_pistol_reload", "sn_gun_reload11");
	_add_sound_pick("hoopz_pistol_reload", "sn_gun_reload12");
	
	
	_add_sound_pick("hoopz_reloadcrossbow", "sn_guncrossbow_reload01");
	_add_sound_pick("hoopz_reloadcrossbow", "sn_guncrossbow_reload02");
	_add_sound_pick("hoopz_reloadcrossbow", "sn_guncrossbow_reload03");

	_add_sound_pick("hoopz_click", "sn_gun_click01");
	_add_sound_pick("hoopz_click", "sn_gun_click02");

	_add_sound_pick("hoopz_swapguns", "sn_gun_swap01");
	_add_sound_pick("hoopz_swapguns", "sn_gun_swap02");
	_add_sound_pick("hoopz_swapguns", "sn_gun_pickup01");
	_add_sound_pick("hoopz_swapguns", "sn_gun_pickup02");

	_add_sound_pick("hoopz_pickupgun", "sn_gun_pickup01");
	_add_sound_pick("hoopz_pickupgun", "sn_gun_pickup02");
	_add_sound_pick("hoopz_pickupgun", "sn_gun_pickup05");

	_add_sound_pick("hoopz_pickupMoney", "sn_hoopz_money1");
	_add_sound_pick("hoopz_pickupMoney", "sn_hoopz_money2");
	_add_sound_pick("hoopz_pickupMoney", "sn_hoopz_money3");

	_add_sound_pick("hoopz_shellcasing_light", "sn_gun_shellcasing_light_01");
	_add_sound_pick("hoopz_shellcasing_light", "sn_gun_shellcasing_light_02");
	_add_sound_pick("hoopz_shellcasing_light", "sn_gun_shellcasing_light_03");
	_add_sound_pick("hoopz_shellcasing_light", "sn_gun_shellcasing_light_04");
	_add_sound_pick("hoopz_shellcasing_light", "sn_gun_shellcasing_light_05");
	_add_sound_pick("hoopz_shellcasing_light", "sn_gun_shellcasing_light_06");
	_add_sound_pick("hoopz_shellcasing_light", "sn_gun_shellcasing_light_07");

	_add_sound_pick("hoopz_shellcasing_medium", "sn_gun_shellcasing_medium_01");
	_add_sound_pick("hoopz_shellcasing_medium", "sn_gun_shellcasing_medium_02");
	_add_sound_pick("hoopz_shellcasing_medium", "sn_gun_shellcasing_medium_03");
	_add_sound_pick("hoopz_shellcasing_medium", "sn_gun_shellcasing_medium_04");
	_add_sound_pick("hoopz_shellcasing_medium", "sn_gun_shellcasing_medium_05");
	_add_sound_pick("hoopz_shellcasing_medium", "sn_gun_shellcasing_medium_06");

	_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_large_01");
	_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_large_02");
	_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_large_03");
	_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_large_04");
	_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_large_05");
	_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_large_06");

	_add_sound_pick("hoopz_shellcasing_heavy", "sn_gun_shellcasing_heavy_01");
	_add_sound_pick("hoopz_shellcasing_heavy", "sn_gun_shellcasing_heavy_02");
	_add_sound_pick("hoopz_shellcasing_heavy", "sn_gun_shellcasing_heavy_03");
	_add_sound_pick("hoopz_shellcasing_heavy", "sn_gun_shellcasing_heavy_04");
	_add_sound_pick("hoopz_shellcasing_heavy", "sn_gun_shellcasing_heavy_05");
	_add_sound_pick("hoopz_shellcasing_heavy", "sn_gun_shellcasing_heavy_06");

	_add_sound_pick("hoopz_shellcasing_shell", "sn_gun_shellcasing_shell_01");
	_add_sound_pick("hoopz_shellcasing_shell", "sn_gun_shellcasing_shell_02");
	_add_sound_pick("hoopz_shellcasing_shell", "sn_gun_shellcasing_shell_03");
	_add_sound_pick("hoopz_shellcasing_shell", "sn_gun_shellcasing_shell_04");
	_add_sound_pick("hoopz_shellcasing_shell", "sn_gun_shellcasing_shell_05");
	_add_sound_pick("hoopz_shellcasing_shell", "sn_gun_shellcasing_shell_06");

	## Bhroom's note for EricW, these were the "large" rifle sounds that felt too "glassy"
	#I've swapped them out for medium sounds below and they seem fine ... the hooks for them
	#are still listed as large if we want to alter the original sounds later
	#_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_medium_01");
	#_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_medium_02");
	#_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_medium_03");
	#_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_medium_04");
	#_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_medium_05");
	#_add_sound_pick("hoopz_shellcasing_large", "sn_gun_shellcasing_medium_06");

	##################
	####AFFIX EFFECTS
	_add_sound_pick("affix_busting", "sn_busted01");

	_add_sound_pick("affix_carapacing", "sn_carapacing01");
	_add_sound_pick("affix_carapacing", "sn_carapacing02");
	_add_sound_pick("affix_carapacing", "sn_carapacing03");

	_add_sound_pick("affix_composting", "sn_composting01");
	_add_sound_pick("affix_composting", "sn_composting02");
	_add_sound_pick("affix_composting", "sn_composting03");

	_add_sound_pick("affix_eightarmed", "sn_eightarmed01");
	_add_sound_pick("affix_eightarmed", "sn_eightarmed02");
	_add_sound_pick("affix_eightarmed", "sn_eightarmed03");

	_add_sound_pick("affix_godless", "sn_godless01");
	_add_sound_pick("affix_godless", "sn_godless02");
	_add_sound_pick("affix_godless", "sn_godless03");

	_add_sound_pick("affix_malnourished", "sn_malnourishing01");
	_add_sound_pick("affix_malnourished", "sn_malnourishing02");
	_add_sound_pick("affix_malnourished", "sn_malnourishing03");

	_add_sound_pick("affix_partitioning", "sn_partitioning01");
	_add_sound_pick("affix_partitioning", "sn_partitioning02");
	_add_sound_pick("affix_partitioning", "sn_partitioning03");

	_add_sound_pick("affix_rebasing", "sn_rebasing01");
	_add_sound_pick("affix_rebasing", "sn_rebasing02");
	_add_sound_pick("affix_rebasing", "sn_rebasing03");

	_add_sound_pick("affix_thorns", "sn_thorns01");
	_add_sound_pick("affix_thorns", "sn_thorns02");
	_add_sound_pick("affix_thorns", "sn_thorns03");

	_add_sound_pick("affix_tubercular", "sn_tubercular01");
	_add_sound_pick("affix_tubercular", "sn_tubercular02");
	_add_sound_pick("affix_tubercular", "sn_tubercular03");

	_add_sound_pick("affix_withering", "sn_withering01");
	_add_sound_pick("affix_withering", "sn_withering02");
	_add_sound_pick("affix_withering", "sn_withering03");

	_add_sound_pick("affix_zaubric", "sn_zaubric01");
	_add_sound_pick("affix_zaubric", "sn_zaubric02");
	_add_sound_pick("affix_zaubric", "sn_zaubric03");

	##################
	####GENERAL
	_add_sound_pick("cursor_back", "sn_cursor_back01");
	_add_sound_pick("cursor_error01", "sn_cursor_error01");
	_add_sound_pick("cursor_move01", "sn_cursor_digitalselect01");
	_add_sound_pick("cursor_select01", "sn_cursor_select01");
	_add_sound_pick("mouse_hover01", "sn_mouse_analoghover01");
	_add_sound_pick("mouse_select01", "sn_mouse_select01");

	####Note from EricW These impact sounds are for when hoopz gets hit with a blunt weapon
	####the general_impact needs to be changed to blunt_impact instead
	#### didn't want to mess with the coding on the other end!
	_add_sound_pick("general_impact", "sn_hoopz_blunthit01");
	_add_sound_pick("general_impact", "sn_hoopz_blunthit02");
	_add_sound_pick("general_impact", "sn_hoopz_blunthit03");
	_add_sound_pick("general_impact", "sn_hoopz_blunthit04");

	_add_sound_pick("ricochet", "sn_bulletricochet01");
	_add_sound_pick("ricochet", "sn_bulletricochet02");
	_add_sound_pick("ricochet", "sn_bulletricochet03");
	_add_sound_pick("ricochet", "sn_bulletricochet04");

	_add_sound_pick("acid_impact", "sn_hoopz_acidhit01");
	_add_sound_pick("acid_impact", "sn_hoopz_acidhit02");
	_add_sound_pick("acid_impact", "sn_hoopz_acidhit03");

	_add_sound_pick("fire_impact", "sn_hoopz_firehit01");
	_add_sound_pick("fire_impact", "sn_hoopz_firehit02");
	_add_sound_pick("fire_impact", "sn_hoopz_firehit03");
	_add_sound_pick("fire_impact", "sn_hoopz_firehit04");

	_add_sound_pick("largebullet_impact", "sn_hoopz_largebullethit01");
	_add_sound_pick("largebullet_impact", "sn_hoopz_largebullethit02");
	_add_sound_pick("largebullet_impact", "sn_hoopz_largebullethit03");

	_add_sound_pick("mediumbullet_impact", "sn_hoopz_mediumbullethit01");
	_add_sound_pick("mediumbullet_impact", "sn_hoopz_mediumbullethit02");
	_add_sound_pick("mediumbullet_impact", "sn_hoopz_mediumbullethit03");

	_add_sound_pick("smallbullet_impact", "sn_hoopz_smallbullethit01");
	_add_sound_pick("smallbullet_impact", "sn_hoopz_smallbullethit02");
	_add_sound_pick("smallbullet_impact", "sn_hoopz_smallbullethit03");

	_add_sound_pick("slash_impact", "sn_hoopz_slashhit01");
	_add_sound_pick("slash_impact", "sn_hoopz_slashhit02");
	_add_sound_pick("slash_impact", "sn_hoopz_slashhit03");
	_add_sound_pick("slash_impact", "sn_hoopz_slashhit04");

	##################
	####NOTE SELECTOR
	_add_sound_pick("note_light", "sn_mnu_noteFlipLight01");
	_add_sound_pick("note_medium", "sn_mnu_noteFlipMedium01");
	_add_sound_pick("note_heavy", "sn_mnu_noteFlipHeavy01");

	##################
	####UTILITY STATION SOUNDS

	_add_sound_pick("utility_open", "sn_utility_open");
	_add_sound_pick("utility_close", "sn_utility_close");

	_add_sound_pick("utility_button_click", "sn_utilitycursor_buttonclick01");
	_add_sound_pick("utility_button_analogclick", "sn_utilitycursor_buttonanalogclick01");
	_add_sound_pick("utility_button_disabled", "sn_utilitycursor_buttondisabled01");


	##################
	####PAUSE MENU SOUNDS

	_add_sound_pick("pausemenu_click", "sn_cursor_pausemenu01");


	##################
	####HUD SOUNDS
	_add_sound_pick("periodic_charged", "sn_periodic_charged01");
	_add_sound_pick("periodic_released", "sn_periodic_released01");
	_add_sound_pick("periodic_charged_muted", "sn_periodic_charged_muted01");
	_add_sound_pick("periodic_released_muted", "sn_periodic_released_muted01");

	################/
	####ENEMIES

	##/explosive rats
	_add_sound_pick("explosiverat_alert", "sn_sewers_explosiverats_alert01");
	_add_sound_pick("explosiverat_alert", "sn_sewers_explosiverats_alert02");
	_add_sound_pick("explosiverat_alert", "sn_sewers_explosiverats_alert03");
	_add_sound_pick("explosiverat_hurt", "sn_sewers_explosiverats_hurt01");
	_add_sound_pick("explosiverat_hurt", "sn_sewers_explosiverats_hurt02");
	_add_sound_pick("explosiverat_hurt", "sn_sewers_explosiverats_hurt03");
	_add_sound_pick("explosiverat_death", "sn_sewers_explosiverats_explode01");
	_add_sound_pick("explosiverat_death", "sn_sewers_explosiverats_explode02");
	_add_sound_pick("explosiverat_death", "sn_sewers_explosiverats_explode03");
	_add_sound_pick("explosiverat_stopandlook", "sn_sewers_explosiverats_alert01");
	_add_sound_pick("explosiverat_stopandlook", "sn_sewers_explosiverats_alert02");
	_add_sound_pick("explosiverat_stopandlook", "sn_sewers_explosiverats_alert03");

	##/ dark rats
	_add_sound_pick("darkrat_alert", "sn_enemy_cyberrat_alert01");
	_add_sound_pick("darkrat_hurt", "sn_enemy_cyberrat_hurt01");
	_add_sound_pick("darkrat_death", "sn_enemy_cyberrat_death01");
	_add_sound_pick("darkrat_stopandlook", "sn_enemy_cyberrat_alert01");

	##/ cyber rats
	_add_sound_pick("cyberrat_alert", "sn_enemy_cyberrat_alert01");
	_add_sound_pick("cyberrat_hurt", "sn_enemy_cyberrat_hurt01");
	_add_sound_pick("cyberrat_death", "sn_enemy_cyberrat_death01");
	_add_sound_pick("cyberrat_stopandlook", "sn_enemy_cyberrat_alert01");

	##/oildrum
	_add_sound_pick("oildrum_hurt", "sn_generic_thinmetal01");
	_add_sound_pick("oildrum_hurt", "sn_generic_thinmetal02");
	_add_sound_pick("oildrum_hurt", "sn_generic_thinmetal03");
	_add_sound_pick("oildrum_death", "sn_oilbarrel_explosion01");
	_add_sound_pick("oildrum_death", "sn_oilbarrel_explosion02");
	_add_sound_pick("oildrum_death", "sn_oilbarrel_explosion03");

	##/cybergremins
	_add_sound_pick("cGremlinSmall_alert", "sn_enemy_cybergremlin_battlecry01");
	_add_sound_pick("cGremlinSmall_alert", "sn_enemy_cybergremlin_battlecry02");
	_add_sound_pick("cGremlinSmall_attack", "sn_enemy_cybergremlin_atk01");
	_add_sound_pick("cGremlinSmall_attack", "sn_enemy_cybergremlin_atk02");
	_add_sound_pick("cGremlinSmall_attack", "sn_enemy_cybergremlin_atk03");
	_add_sound_pick("cGremlinSmall_gunattack", "sn_enemy_cybergremlin_gun01");
	_add_sound_pick("cGremlinSmall_gunattack", "sn_enemy_cybergremlin_gun02");
	_add_sound_pick("cGremlinSmall_gunattack", "sn_enemy_cybergremlin_gun03");
	_add_sound_pick("cGremlinSmall_gunattack", "sn_enemy_cybergremlin_gun04");
	_add_sound_pick("cGremlinSmall_death", "sn_enemy_cybergremlin_death01");
	_add_sound_pick("cGremlinSmall_death", "sn_enemy_cybergremlin_death02");
	_add_sound_pick("cGremlinSmall_death", "sn_enemy_cybergremlin_death03");
	_add_sound_pick("cGremlinSmall_grunt", "sn_enemy_cybergremlin_grunt01");
	_add_sound_pick("cGremlinSmall_grunt", "sn_enemy_cybergremlin_grunt02");
	_add_sound_pick("cGremlinSmall_grunt", "sn_enemy_cybergremlin_grunt03");
	_add_sound_pick("cGremlinSmall_grunt", "sn_enemy_cybergremlin_grunt04");
	_add_sound_pick("cGremlinSmall_scream", "sn_enemy_cybergremlin_scream01");
	_add_sound_pick("cGremlinSmall_scream", "sn_enemy_cybergremlin_scream02");
	_add_sound_pick("cGremlinSmall_swipe", "sn_enemy_cybergremlin_swipe01");
	_add_sound_pick("cGremlinSmall_swipe", "sn_enemy_cybergremlin_swipe02");
	_add_sound_pick("cGremlinSmall_swipe", "sn_enemy_cybergremlin_swipe03");
	_add_sound_pick("cGremlinSmall_swipe", "sn_enemy_cybergremlin_swipe04");
	_add_sound_pick("cGremlinJetpack_hover", "sn_enemy_cybergremlin_jetpack1");
	_add_sound_pick("cGremlinJetpack_hover", "sn_enemy_cybergremlin_jetpack2");
	_add_sound_pick("cGremlinJetpack_hover", "sn_enemy_cybergremlin_jetpack3");

	##/duergars
	_add_sound_pick("duergar_alert", "sn_enemy_duergar_battlecry01");
	_add_sound_pick("duergar_alert", "sn_enemy_duergar_battlecry02");                       
	_add_sound_pick("duergar_death", "sn_enemy_duergar_death01");
	_add_sound_pick("duergar_death", "sn_enemy_duergar_death02");
	_add_sound_pick("duergar_death", "sn_enemy_duergar_death03");
	_add_sound_pick("duergar_grunt", "sn_enemy_duergar_grunt01");
	_add_sound_pick("duergar_grunt", "sn_enemy_duergar_grunt02");
	_add_sound_pick("duergar_grunt", "sn_enemy_duergar_grunt03");
	_add_sound_pick("duergar_shot", "sn_enemy_duergar_shot01");
	_add_sound_pick("duergar_shot", "sn_enemy_duergar_shot02");
	_add_sound_pick("duergar_footstep", "sn_enemy_duergar_leftfoot");
	_add_sound_pick("duergar_footstep", "sn_enemy_duergar_rightfoot");
	_add_sound_pick("duergar_brute_swipe", "sn_enemy_duergar_swipe01");
	_add_sound_pick("duergar_brute_swipe", "sn_enemy_duergar_swipe02");
	_add_sound_pick("duergar_brute_swipe", "sn_enemy_duergar_swipe03");
	_add_sound_pick("duergar_brute_impact", "sn_enemy_duergar_impact01");
	_add_sound_pick("duergar_brute_impact", "sn_enemy_duergar_impact02");
	_add_sound_pick("duergar_brute_impact", "sn_enemy_duergar_impact03");
	_add_sound_pick("duergar_wizard_alert", "sn_enemy_duergar_wizardcry01");
	_add_sound_pick("duergar_wizard_fireball", "sn_enemy_duergars_wizardfireball01");
	_add_sound_pick("duergar_wizard_fireball", "sn_enemy_duergars_wizardfireball02");
	_add_sound_pick("duergar_wizard_fireball", "sn_enemy_duergars_wizardfireball03");
	_add_sound_pick("duergar_shield", "sn_generic_metalres01");
	_add_sound_pick("duergar_shield", "sn_generic_metalres02");
	_add_sound_pick("duergar_shield", "sn_generic_metalres03");

	####sewerbeasts
	_add_sound_pick("sewerbeast_alert", "sn_enemy_sewerbeast_battlecry01");
	_add_sound_pick("sewerbeast_alert", "sn_enemy_sewerbeast_battlecry02");
	_add_sound_pick("sewerbeast_warn", "sn_enemy_sewerbeast_scream01");
	_add_sound_pick("sewerbeast_warn", "sn_enemy_sewerbeast_scream02");
	_add_sound_pick("sewerbeast_whip", "sn_sewerbeastwhip01");
	_add_sound_pick("sewerbeast_whip", "sn_sewerbeastwhip02");
	_add_sound_pick("sewerbeast_whip", "sn_sewerbeastwhip03");
	_add_sound_pick("sewerbeast_spit", "sn_enemy_sewerbeast_spit01");
	_add_sound_pick("sewerbeast_spit", "sn_enemy_sewerbeast_spit02");
	_add_sound_pick("sewerbeast_spit", "sn_enemy_sewerbeast_spit03");
	_add_sound_pick("sewerbeast_hit", "sn_enemy_sewerbeast_hit01");
	_add_sound_pick("sewerbeast_hit", "sn_enemy_sewerbeast_hit02");
	_add_sound_pick("sewerbeast_death", "sn_enemy_sewerbeast_death01");
	_add_sound_pick("sewerbeast_death", "sn_enemy_sewerbeast_death02");
	_add_sound_pick("sewerbeast_death", "sn_enemy_sewerbeast_death03");
	_add_sound_pick("sewerbeast_jump", "sn_enemy_sewerbeast_jump01");
	####sewerbeast jr
	_add_sound_pick("sewerbeastJr_alert", "sn_enemy_sewerbeastjr_scream01");
	_add_sound_pick("sewerbeastJr_alert", "sn_enemy_sewerbeastjr_scream02");
	_add_sound_pick("swerebeastJr_warn", "sn_enemy_sewerbeast_battlecryjr01");
	_add_sound_pick("sewerbeastJr_warn", "sn_enemy_sewerbeast_battlecryjr02");
	_add_sound_pick("sewerbeastJr_warn", "sn_enemy_sewerbeast_battlecryjr03");
	_add_sound_pick("sewerbeastJr_hit", "sn_enemy_sewerbeast_hitjr01");
	_add_sound_pick("sewerbeastJr_hit", "sn_enemy_sewerbeast_hitjr02");
	_add_sound_pick("sewerbeastJr_hit", "sn_enemy_sewerbeast_hitjr03"); 
	_add_sound_pick("sewerbeastJr_spit", "sn_enemy_sewerbeastjr_spit01");
	_add_sound_pick("sewerbeastJr_spit", "sn_enemy_sewerbeastjr_spit02");
	_add_sound_pick("sewerbeastJr_spit", "sn_enemy_sewerbeastjr_spit03");
	_add_sound_pick("sewerbeastJr_death", "sn_enemy_sewerbeastjr_death01");
	_add_sound_pick("sewerbeastJr_death", "sn_enemy_sewerbeastjr_death02");
	_add_sound_pick("sewerbeastJr_death", "sn_enemy_sewerbeastjr_death03");
	####swampman
	_add_sound_pick("swampman_alert", "sn_enemy_swampman_battlecry01");
	_add_sound_pick("swampman_alert", "sn_enemy_swampman_battlecry02");
	_add_sound_pick("swampman_alert", "sn_enemy_swampman_battlecry03");
	_add_sound_pick("swampman_warn", "sn_enemy_swampman_atk01");
	_add_sound_pick("swampman_warn", "sn_enemy_swampman_atk02");
	_add_sound_pick("swampman_warn", "sn_enemy_swampman_atk03");
	_add_sound_pick("swampman_strike", "sn_enemy_swampman_strike01"); 
	_add_sound_pick("swampman_strike", "sn_enemy_swampman_strike02"); 
	_add_sound_pick("swampman_strike", "sn_enemy_swampman_strike03"); 
	_add_sound_pick("swampman_footstepwater", "sn_enemy_swampman_leftfootwater01");
	_add_sound_pick("swampman_footstepwater", "sn_enemy_swampman_rightfootwater01");
	_add_sound_pick("swampman_footstepland", "sn_enemy_swampman_leftfootland01");
	_add_sound_pick("swampman_footstepland", "sn_enemy_swampman_rightfootland01");
	_add_sound_pick("swampman_death", "sn_enemy_swampman_death01");
	_add_sound_pick("swampman_death", "sn_enemy_swampman_death02");
	_add_sound_pick("swampman_death", "sn_enemy_swampman_death03");
	_add_sound_pick("swampman_hurt", "sn_enemy_swampman_grunt01");
	_add_sound_pick("swampman_hurt", "sn_enemy_swampman_grunt02");
	_add_sound_pick("swampman_hurt", "sn_enemy_swampman_grunt03");
	####kobold
	_add_sound_pick("kobold_charge_small", "sn_enemy_kobold_small_atk01");
	_add_sound_pick("kobold_charge_small", "sn_enemy_kobold_small_atk02");
	_add_sound_pick("kobold_charge_small", "sn_enemy_kobold_small_atk03");

	_add_sound_pick("kobold_charge_med", "sn_enemy_kobold_medium_atk01");
	_add_sound_pick("kobold_charge_med", "sn_enemy_kobold_medium_atk02");
	_add_sound_pick("kobold_charge_med", "sn_enemy_kobold_medium_atk03");

	_add_sound_pick("kobold_grunt_small", "sn_enemy_kobold_small_grunt01");
	_add_sound_pick("kobold_grunt_small", "sn_enemy_kobold_small_grunt02");
	_add_sound_pick("kobold_grunt_small", "sn_enemy_kobold_small_grunt03");

	_add_sound_pick("kobold_death_small", "sn_enemy_kobold_small_death01");
	_add_sound_pick("kobold_death_small", "sn_enemy_kobold_small_death01");
	_add_sound_pick("kobold_death_small", "sn_enemy_kobold_small_death01");
	_add_sound_pick("kobold_death_small", "sn_enemy_kobold_small_death01");

	_add_sound_pick("kobold_splatter", "sn_enemy_kobold_splatter01");
	_add_sound_pick("kobold_splatter", "sn_enemy_kobold_splatter02");
	_add_sound_pick("kobold_splatter", "sn_enemy_kobold_splatter03");
	_add_sound_pick("kobold_splatter", "sn_enemy_kobold_splatter04");
	_add_sound_pick("kobold_splatter", "sn_enemy_kobold_splatter05");
	_add_sound_pick("kobold_splatter", "sn_enemy_kobold_splatter06");

	_add_sound_pick("kobold_spawn", "sn_enemy_kobold_clone01");
	_add_sound_pick("kobold_spawn", "sn_enemy_kobold_clone02");
	_add_sound_pick("kobold_spawn", "sn_enemy_kobold_clone03");

	_add_sound_pick("kobold_alert", "sn_enemy_kobold_medium_battlecry01");
	_add_sound_pick("kobold_alert", "sn_enemy_kobold_medium_battlecry02");
	_add_sound_pick("kobold_alert", "sn_enemy_kobold_medium_battlecry03");
	_add_sound_pick("kobold_alert", "sn_enemy_kobold_medium_battlecry04");
	_add_sound_pick("kobold_attack", "sn_enemy_kobold_medium_atk01");
	_add_sound_pick("kobold_attack", "sn_enemy_kobold_medium_atk02");
	_add_sound_pick("kobold_attack", "sn_enemy_kobold_medium_atk03");
	_add_sound_pick("kobold_attack", "sn_enemy_kobold_medium_atk04");
	_add_sound_pick("kobold_clone", "sn_enemy_kobold_clone01");
	_add_sound_pick("kobold_clone", "sn_enemy_kobold_clone02");
	_add_sound_pick("kobold_clone", "sn_enemy_kobold_clone03");
	_add_sound_pick("kobold_death", "sn_enemy_kobold_medium_death01");
	_add_sound_pick("kobold_death", "sn_enemy_kobold_medium_death02");
	_add_sound_pick("kobold_death", "sn_enemy_kobold_medium_death03");
	_add_sound_pick("kobold_death", "sn_enemy_kobold_medium_death04");
	_add_sound_pick("kobold_grunt", "sn_enemy_kobold_medium_grunt01");
	_add_sound_pick("kobold_grunt", "sn_enemy_kobold_medium_grunt02");
	_add_sound_pick("kobold_grunt", "sn_enemy_kobold_medium_grunt03");
	_add_sound_pick("kobold_swipe", "sn_enemy_kobold_swipe01");
	_add_sound_pick("kobold_swipe", "sn_enemy_kobold_swipe02");
	_add_sound_pick("kobold_swipe", "sn_enemy_kobold_swipe03");
	_add_sound_pick("kobold_spit", "sn_enemy_kobold_spit01");
	_add_sound_pick("kobold_spit", "sn_enemy_kobold_spit02");
	_add_sound_pick("kobold_spit", "sn_enemy_kobold_spit03");
	
	##/Plant Mimic
	_add_sound_pick("plantmimic_death", "sn_plantmimic_death01");
	_add_sound_pick("plantmimic_death", "sn_plantmimic_death02");
	_add_sound_pick("plantmimic_death", "sn_plantmimic_death03");
	_add_sound_pick("plantmimic_scream", "sn_plantmimic_battlecry01");
	_add_sound_pick("plantmimic_scream", "sn_plantmimic_battlecry02");
	_add_sound_pick("plantmimic_scream", "sn_plantmimic_battlecry03");
	_add_sound_pick("plantmimic_hurt", "sn_plantmimic_hurt01");
	_add_sound_pick("plantmimic_hurt", "sn_plantmimic_hurt02");
	_add_sound_pick("plantmimic_hurt", "sn_plantmimic_hurt03");
	_add_sound_pick("plantmimic_warn", "sn_plantmimic_warn01");
	_add_sound_pick("plantmimic_warn", "sn_plantmimic_warn02");
	_add_sound_pick("plantmimic_warn", "sn_plantmimic_warn03");
	_add_sound_pick("plantmimic_strike", "sn_plantmimic_strike01");
	_add_sound_pick("plantmimic_strike", "sn_plantmimic_strike02");
	_add_sound_pick("plantmimic_strike", "sn_plantmimic_strike03");

	## vine monster
	_add_sound_pick("vinemonster_death", "sn_enemy_vinemonster_death01");
	_add_sound_pick("vinemonster_death", "sn_enemy_vinemonster_death02");
	_add_sound_pick("vinemonster_death", "sn_enemy_vinemonster_death03");
	_add_sound_pick("vinemonster_hurt", "sn_enemy_vinemonster_hurt01");
	_add_sound_pick("vinemonster_hurt", "sn_enemy_vinemonster_hurt02");
	_add_sound_pick("vinemonster_hurt", "sn_enemy_vinemonster_hurt03");
	_add_sound_pick("vinemonster_alert", "sn_enemy_vinemonster_alert01");
	_add_sound_pick("vinemonster_alert", "sn_enemy_vinemonster_alert02");
	_add_sound_pick("vinemonster_alert", "sn_enemy_vinemonster_alert03");
	_add_sound_pick("vinemonster_scream", "sn_enemy_vinemonster_scream01");
	_add_sound_pick("vinemonster_scream", "sn_enemy_vinemonster_scream02");
	_add_sound_pick("vinemonster_scream", "sn_enemy_vinemonster_scream03");
	_add_sound_pick("vinemonster_spit", "sn_enemy_vinemonster_spit01");
	_add_sound_pick("vinemonster_spit", "sn_enemy_vinemonster_spit02");
	_add_sound_pick("vinemonster_spit", "sn_enemy_vinemonster_spit03");

	## junkbot
	_add_sound_pick("junkbot_death", "sn_junkbot_death01");
	_add_sound_pick("junkbot_death", "sn_junkbot_death02");
	_add_sound_pick("junkbot_death", "sn_junkbot_death03");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt01");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt02");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt03");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt04");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt05");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt06");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt07");
	_add_sound_pick("junkbot_hurt", "sn_junkbot_hurt08");
	_add_sound_pick("junkbot_chainsaw", "sn_junkbot_chainsaw01");
	_add_sound_pick("junkbot_chainsaw", "sn_junkbot_chainsaw02");
	_add_sound_pick("junkbot_chainsaw", "sn_junkbot_chainsaw03");
	_add_sound_pick("junkbot_pickuppart", "sn_junkbot_pickuppart01");
	_add_sound_pick("junkbot_pickuppart", "sn_junkbot_pickuppart02");
	_add_sound_pick("junkbot_pickuppart", "sn_junkbot_pickuppart03");
	_add_sound_pick("junkbot_connectpart", "sn_junkbot_connectpart01");
	_add_sound_pick("junkbot_connectpart", "sn_junkbot_connectpart02");
	_add_sound_pick("junkbot_connectpart", "sn_junkbot_connectpart03");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink01");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink02");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink03");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink04");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink05");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink06");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink07");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink08");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink09");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink10");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink11");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink12");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink13");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink14");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink15");
	_add_sound_pick("junkbot_death_partclink", "sn_junkbot_partclink16");
	_add_sound_pick("junkbot_tires_hop", "sn_junkbot_tires_hop01");
	_add_sound_pick("junkbot_tires_hop", "sn_junkbot_tires_hop02");
	_add_sound_pick("junkbot_tires_hop", "sn_junkbot_tires_hop03");
	_add_sound_pick("junkbot_tires_land", "sn_junkbot_tires_land01");
	_add_sound_pick("junkbot_tires_land", "sn_junkbot_tires_land02");
	_add_sound_pick("junkbot_tires_land", "sn_junkbot_tires_land03");
	_add_sound_pick("junkbot_washingmachine_rumble", "sn_junkbot_washingmachine01");
	_add_sound_pick("junkbot_washingmachine_rumble", "sn_junkbot_washingmachine02");
	_add_sound_pick("junkbot_washingmachine_rumble", "sn_junkbot_washingmachine03");
	_add_sound_pick("junkbot_washingmachine_rumble", "sn_junkbot_washingmachine04");
	_add_sound_pick("junkbot_washingmachine_rumble", "sn_junkbot_washingmachine05");
	_add_sound_pick("junkbot_missile_fire", "sn_junkbot_missile_fire01");
	_add_sound_pick("junkbot_missile_fire", "sn_junkbot_missile_fire02");
	_add_sound_pick("junkbot_missile_fire", "sn_junkbot_missile_fire03");
	_add_sound_pick("junkbot_missile_impact", "sn_junkbot_missile_impact01");
	_add_sound_pick("junkbot_missile_impact", "sn_junkbot_missile_impact02");
	_add_sound_pick("junkbot_missile_impact", "sn_junkbot_missile_impact03");
	_add_sound_pick("junkbot_gas_spray", "sn_junkbot_gas_spray01");
	_add_sound_pick("junkbot_gas_spray", "sn_junkbot_gas_spray02");
	_add_sound_pick("junkbot_gas_spray", "sn_junkbot_gas_spray03");
	_add_sound_pick("junkbot_flamethrower_flare", "sn_junkbot_flame01");
	_add_sound_pick("junkbot_flamethrower_flare", "sn_junkbot_flame02");
	_add_sound_pick("junkbot_flamethrower_flare", "sn_junkbot_flame03");
	_add_sound_pick("junkbot_flamethrower_breath", "sn_junkbot_breath01");
	_add_sound_pick("junkbot_flamethrower_breath", "sn_junkbot_breath02");
	_add_sound_pick("junkbot_flamethrower_breath", "sn_junkbot_breath03");

	####brain menace
	_add_sound_pick("brainmenace_footstep", "sn_enemy_brainmenace_frontstride01");
	_add_sound_pick("brainmenace_attack", "sn_enemy_brainmenace_atk01");
	_add_sound_pick("brainmenace_attack", "sn_enemy_brainmenace_atk02");
	_add_sound_pick("brainmenace_attack", "sn_enemy_brainmenace_atk03");
	_add_sound_pick("brainmenace_attack", "sn_enemy_brainmenace_atk04");
	_add_sound_pick("brainmenace_grunt", "sn_enemy_brainmenace_grunt01");
	_add_sound_pick("brainmenace_grunt", "sn_enemy_brainmenace_grunt02");
	_add_sound_pick("brainmenace_grunt", "sn_enemy_brainmenace_grunt03");
	_add_sound_pick("brainmenace_grunt", "sn_enemy_brainmenace_grunt04");
	_add_sound_pick("brainmenace_death", "sn_enemy_brainmenace_death01");
	_add_sound_pick("brainmenace_death", "sn_enemy_brainmenace_death02");
	_add_sound_pick("brainmenace_death", "sn_enemy_brainmenace_death03");
	_add_sound_pick("brainmenace_scream", "sn_enemy_brainmenace_scream01");
	_add_sound_pick("brainmenace_scream", "sn_enemy_brainmenace_scream02");
	_add_sound_pick("brainmenace_tackle", "sn_enemy_brainmenace_tackle01");
	_add_sound_pick("brainmenace_tackle", "sn_enemy_brainmenace_tackle02");
	_add_sound_pick("brainmenace_tackle", "sn_enemy_brainmenace_tackle03");
	_add_sound_pick("brainmenace_slash", "sn_enemy_brainmenace_slash01");
	_add_sound_pick("brainmenace_slash", "sn_enemy_brainmenace_slash02");
	_add_sound_pick("brainmenace_slash", "sn_enemy_brainmenace_slash03");

	_add_sound_pick("brainmenace_death", "sn_enemy_brainmenace_death01");
	_add_sound_pick("brainmenace_death", "sn_enemy_brainmenace_death02");
	_add_sound_pick("brainmenace_death", "sn_enemy_brainmenace_death03");

	_add_sound_pick("brainmenace_hurt", "sn_enemy_brainmenace_grunt01");
	_add_sound_pick("brainmenace_hurt", "sn_enemy_brainmenace_grunt02");
	_add_sound_pick("brainmenace_hurt", "sn_enemy_brainmenace_grunt03");

	_add_sound_pick("brainmenace_fallonback", "sn_enemy_brainmenace_frontstride01");

	_add_sound_pick("brainmenace_leap_prepare", "sn_enemy_brainmenace_prepare01");
	_add_sound_pick("brainmenace_leap_prepare", "sn_enemy_brainmenace_prepare02");
	_add_sound_pick("brainmenace_leap_prepare", "sn_enemy_brainmenace_prepare03");
	_add_sound_pick("brainmenace_leap_jump", "sn_enemy_brainmenace_jump01");
	_add_sound_pick("brainmenace_leap_jump", "sn_enemy_brainmenace_jump02");
	_add_sound_pick("brainmenace_leap_jump", "sn_enemy_brainmenace_jump03");
	_add_sound_pick("brainmenace_leap_smash", "sn_enemy_brainmenace_smash01");
	_add_sound_pick("brainmenace_leap_smash", "sn_enemy_brainmenace_smash02");
	_add_sound_pick("brainmenace_leap_smash", "sn_enemy_brainmenace_smash03");

	####/ alien egg 
	_add_sound_pick("brainegg_hatch", "sn_enemy_babyalien_birth01");
	_add_sound_pick("brainegg_hatch", "sn_enemy_babyalien_birth02");

	_add_sound_pick("brainegg_hurt", "sn_enemy_babyalien_egghurt01");
	_add_sound_pick("brainegg_hurt", "sn_enemy_babyalien_egghurt02");
	_add_sound_pick("brainegg_hurt", "sn_enemy_babyalien_egghurt03");

	_add_sound_pick("brainegg_death", "sn_enemy_babyalien_death01");
	_add_sound_pick("brainegg_death", "sn_enemy_babyalien_death02");
	_add_sound_pick("brainegg_death", "sn_enemy_babyalien_death03");

	####/baby alien
	_add_sound_pick("brainbaby_alert", "sn_enemy_babyalien_alert01");
	_add_sound_pick("brainbaby_alert", "sn_enemy_babyalien_alert02");
	_add_sound_pick("brainbaby_alert", "sn_enemy_babyalien_alert03");

	_add_sound_pick("brainbaby_hurt", "sn_enemy_babyalien_hurt01");
	_add_sound_pick("brainbaby_hurt", "sn_enemy_babyalien_hurt02");
	_add_sound_pick("brainbaby_hurt", "sn_enemy_babyalien_hurt03");

	_add_sound_pick("brainbaby_attack", "sn_enemy_babyalien_atk01");
	_add_sound_pick("brainbaby_attack", "sn_enemy_babyalien_atk02");
	_add_sound_pick("brainbaby_attack", "sn_enemy_babyalien_atk03");

	_add_sound_pick("brainbaby_birth", "sn_enemy_babyalien_birth01");
	_add_sound_pick("brainbaby_birth", "sn_enemy_babyalien_birth02");
	_add_sound_pick("brainbaby_death", "sn_enemy_babyalien_death01");
	_add_sound_pick("brainbaby_death", "sn_enemy_babyalien_death02");
	_add_sound_pick("brainbaby_death", "sn_enemy_babyalien_death03");

	## NOT USED
	##_add_sound_pick("brainbaby_swipe", "sn_enemy_babyalien_swipe01");
	##_add_sound_pick("brainbaby_swipe", "sn_enemy_babyalien_swipe02");
	##_add_sound_pick("brainbaby_swipe", "sn_enemy_babyalien_swipe03");

	####werecrocs
	_add_sound_pick("croc_death", "sn_werecroc_death01");
	_add_sound_pick("croc_death", "sn_werecroc_death02");
	_add_sound_pick("croc_death", "sn_werecroc_death03");
	_add_sound_pick("croc_grunt", "sn_werecroc_grunt01");
	_add_sound_pick("croc_grunt", "sn_werecroc_grunt02");
	_add_sound_pick("croc_grunt", "sn_werecroc_grunt03");
	_add_sound_pick("croc_attack", "sn_werecroc_attack01");
	_add_sound_pick("croc_attack", "sn_werecroc_attack02");
	_add_sound_pick("croc_attack", "sn_werecroc_attack03");
	_add_sound_pick("croc_hunger", "sn_werecroc_hunger01");
	_add_sound_pick("croc_hunger", "sn_werecroc_hunger02");
	_add_sound_pick("croc_hunger", "sn_werecroc_hunger03");
	_add_sound_pick("croc_snap_kill", "sn_werecroc_snapkill01");
	_add_sound_pick("croc_snap_kill", "sn_werecroc_snapkill02");
	_add_sound_pick("croc_snap_kill", "sn_werecroc_snapkill03");
	_add_sound_pick("croc_warn", "sn_werecroc_prehit01");
	_add_sound_pick("croc_warn", "sn_werecroc_prehit02");
	_add_sound_pick("croc_warn", "sn_werecroc_prehit03");

	####weresnails
	_add_sound_pick("weresnail_death", "sn_weresnail_death01");
	_add_sound_pick("weresnail_death", "sn_weresnail_death02");
	_add_sound_pick("weresnail_death", "sn_weresnail_death03");
	_add_sound_pick("weresnail_hurt", "sn_weresnail_hurt01");
	_add_sound_pick("weresnail_hurt", "sn_weresnail_hurt02");
	_add_sound_pick("weresnail_hurt", "sn_weresnail_hurt03");
	_add_sound_pick("weresnail_battlecry", "sn_weresnail_battlecry01");
	_add_sound_pick("weresnail_battlecry", "sn_weresnail_battlecry02");
	_add_sound_pick("weresnail_battlecry", "sn_weresnail_battlecry03");
	_add_sound_pick("weresnail_warn", "sn_weresnail_attack01");
	_add_sound_pick("weresnail_warn", "sn_weresnail_attack02");
	_add_sound_pick("weresnail_warn", "sn_weresnail_attack03");
	_add_sound_pick("weresnail_shoot", "sn_weresnail_shotgun01");
	_add_sound_pick("weresnail_shoot", "sn_weresnail_shotgun02");
	_add_sound_pick("weresnail_shoot", "sn_weresnail_shotgun03");
	_add_sound_pick("weresnail_swim", "sn_weresnail_swim01");
	_add_sound_pick("weresnail_swim", "sn_weresnail_swim02");
	_add_sound_pick("weresnail_swim", "sn_weresnail_swim03");
	_add_sound_pick("weresnail_slime", "sn_weresnail_slime01");
	_add_sound_pick("weresnail_slime", "sn_weresnail_slime02");
	_add_sound_pick("weresnail_slime", "sn_weresnail_slime03");

	####/Catfish
	##############
	##Catfish small
	_add_sound_pick("catfishsmall_death", "sn_catfishsmall_death01");
	_add_sound_pick("catfishsmall_death", "sn_catfishsmall_death02");
	_add_sound_pick("catfishsmall_death", "sn_catfishsmall_death03");
	_add_sound_pick("catfishsmall_grunt", "sn_catfishsmall_grunt01");
	_add_sound_pick("catfishsmall_grunt", "sn_catfishsmall_grunt02");
	_add_sound_pick("catfishsmall_grunt", "sn_catfishsmall_grunt03");
	_add_sound_pick("catfishsmall_alert", "sn_catfishsmall_alert01");
	_add_sound_pick("catfishsmall_alert", "sn_catfishsmall_alert02");
	_add_sound_pick("catfishsmall_alert", "sn_catfishsmall_alert03");
	_add_sound_pick("catfishsmall_attack", "sn_catfishsmall_atk01");
	_add_sound_pick("catfishsmall_attack", "sn_catfishsmall_atk02");
	_add_sound_pick("catfishsmall_attack", "sn_catfishsmall_atk03");
	_add_sound_pick("catfishsmall_shoot", "sn_catfishsmall_dart01");
	_add_sound_pick("catfishsmall_shoot", "sn_catfishsmall_dart02");
	_add_sound_pick("catfishsmall_shoot", "sn_catfishsmall_dart03");
	_add_sound_pick("catfishsmall_pegbreak", "sn_catfishsmall_pegbreak01");
	_add_sound_pick("catfishsmall_pegbreak", "sn_catfishsmall_pegbreak02");
	_add_sound_pick("catfishsmall_pegbreak", "sn_catfishsmall_pegbreak03");

	##Catfish shield
	_add_sound_pick("catfishshield_death", "sn_catfishshield_death01");
	_add_sound_pick("catfishshield_death", "sn_catfishshield_death02");
	_add_sound_pick("catfishshield_death", "sn_catfishshield_death03");
	_add_sound_pick("catfishshield_grunt", "sn_catfishshield_grunt01");
	_add_sound_pick("catfishshield_grunt", "sn_catfishshield_grunt02");
	_add_sound_pick("catfishshield_grunt", "sn_catfishshield_grunt03");
	_add_sound_pick("catfishshield_alert", "sn_catfishsmall_alert01");
	_add_sound_pick("catfishshield_alert", "sn_catfishsmall_alert02");
	_add_sound_pick("catfishshield_alert", "sn_catfishsmall_alert03");
	_add_sound_pick("catfishshield_attack", "sn_catfishshield_atk01");
	_add_sound_pick("catfishshield_attack", "sn_catfishshield_atk02");
	_add_sound_pick("catfishshield_attack", "sn_catfishshield_atk03");
	_add_sound_pick("catfishshield_strike", "sn_catfishshield_meleeattack01");
	_add_sound_pick("catfishshield_strike", "sn_catfishshield_meleeattack02");
	_add_sound_pick("catfishshield_strike", "sn_catfishshield_meleeattack03");
	_add_sound_pick("catfishshield_netswing", "sn_catfishshield_netswing01");
	_add_sound_pick("catfishshield_netswing", "sn_catfishshield_netswing02");
	_add_sound_pick("catfishshield_netswing", "sn_catfishshield_netswing03");
	_add_sound_pick("catfishshield_netthrow", "sn_catfishshield_netthrow01");
	_add_sound_pick("catfishshield_netthrow", "sn_catfishshield_netthrow02");
	_add_sound_pick("catfishshield_netthrow", "sn_catfishshield_netthrow03");

	## Catfish nets
	_add_sound_pick("catfish_net_impact", "sn_catfishshield_netimpact01");
	_add_sound_pick("catfish_net_impact", "sn_catfishshield_netimpact02");
	_add_sound_pick("catfish_net_impact", "sn_catfishshield_netimpact03");
	_add_sound_pick("catfish_net_netbreak", "sn_catfishshield_linebreak01");
	_add_sound_pick("catfish_net_netbreak", "sn_catfishshield_linebreak02");
	_add_sound_pick("catfish_net_netbreak", "sn_catfishshield_linebreak03");
	_add_sound_pick("catfish_net_netbreak", "sn_catfishshield_linebreak04");
	_add_sound_pick("catfish_net_netbreak", "sn_catfishshield_linebreak05");
	_add_sound_pick("catfish_net_pegbreak", "sn_catfishsmall_pegbreak01");
	_add_sound_pick("catfish_net_pegbreak", "sn_catfishsmall_pegbreak02");
	_add_sound_pick("catfish_net_pegbreak", "sn_catfishsmall_pegbreak03");
	##############

	_add_sound_pick("catfish_guts_pickup", "sn_fishbonepickup01");


	####/Junkbots
	##############
	##General
	_add_sound_pick("junkbot_alert", "sn_junkbot_alarm01");
	_add_sound_pick("junkbot_alert", "sn_junkbot_alarm02");
	_add_sound_pick("junkbot_alert", "sn_junkbot_alarm03");
	_add_sound_pick("junkbot_attack", "sn_junkbot_beatmatk01");
	_add_sound_pick("junkbot_shot", "sn_junkbot_laseratk01");
	##Skirmisher
	_add_sound_pick("skirmisher_laser_warn", "sn_junkbot_laseratk01");
	_add_sound_pick("skirmisher_laser_active", "sn_junkbot_lasersustain01");
	_add_sound_pick("skirmisher_laser_end", "sn_junkbot_laserrealease01");

	##Clamps
	_add_sound_pick("clamps_slash", "sn_debug_one");

	####/Crabotron
	##############
	_add_sound_pick("crab_leg_lift", "sn_crabtron_legmotor01");
	_add_sound_pick("crab_leg_lift", "sn_crabtron_legmotor02");
	_add_sound_pick("crab_leg_lift", "sn_crabtron_legmotor03");
	_add_sound_pick("crab_leg_land", "sn_crabtron_footstep01");
	_add_sound_pick("crab_leg_land", "sn_crabtron_footstep02");
	_add_sound_pick("crab_leg_land", "sn_crabtron_footstep03");
	_add_sound_pick("crab_leg_land", "sn_crabtron_footstep04");
	_add_sound_pick("crab_chatter", "sn_crabtron_alert01");
	_add_sound_pick("crab_chatter", "sn_crabtron_alert02");
	_add_sound_pick("crab_chatter", "sn_crabtron_alert03");
	_add_sound_pick("crab_chatter", "sn_crabtron_alert04");
	## Jump
	_add_sound_pick("crab_jump", "sn_crabtron_jump01");
	_add_sound_pick("crab_jump", "sn_crabtron_jump02");
	_add_sound_pick("crab_jump", "sn_crabtron_jump03");
	_add_sound_pick("crab_land", "sn_crabtron_land01");
	_add_sound_pick("crab_land", "sn_crabtron_land02");
	_add_sound_pick("crab_land", "sn_crabtron_land03");
	## Furnace
	_add_sound_pick("crab_furnace_flare", "sn_crabtron_furnaceflare01");
	_add_sound_pick("crab_furnace_flare", "sn_crabtron_furnaceflare02");
	_add_sound_pick("crab_furnace_flare", "sn_crabtron_furnaceflare03");
	_add_sound_pick("crab_furnace_breath", "sn_crabtron_furnacebreath01");
	_add_sound_pick("crab_furnace_breath", "sn_crabtron_furnacebreath02");
	_add_sound_pick("crab_furnace_breath", "sn_crabtron_furnacebreath03");
	## Photon
	_add_sound_pick("crab_photon_spawnleg", "sn_crabtron_photonspawn01");
	_add_sound_pick("crab_photon_spawnleg", "sn_crabtron_photonspawn02");
	_add_sound_pick("crab_photon_spawnleg", "sn_crabtron_photonspawn03");
	_add_sound_pick("crab_photon_spawnleg", "sn_crabtron_photonspawn04");
	_add_sound_pick("crab_photon_spawnhead", "sn_crabtron_photonspawn01");
	_add_sound_pick("crab_photon_spawnhead", "sn_crabtron_photonspawn02");
	_add_sound_pick("crab_photon_spawnhead", "sn_crabtron_photonspawn03");
	_add_sound_pick("crab_photon_spawnhead", "sn_crabtron_photonspawn04");
	_add_sound_pick("crab_photon_land", "sn_crabtron_photonland01");
	_add_sound_pick("crab_photon_land", "sn_crabtron_photonland02");
	_add_sound_pick("crab_photon_land", "sn_crabtron_photonland03");
	_add_sound_pick("crab_photon_land", "sn_crabtron_photonland04");
	_add_sound_pick("crab_photon_looping", "sn_crabtron_photonloop01");
	_add_sound_pick("crab_photon_looping", "sn_crabtron_photonloop02");
	_add_sound_pick("crab_photon_looping", "sn_crabtron_photonloop03");
	_add_sound_pick("crab_photon_looping", "sn_crabtron_photonloop04");
	## Bullet VS Metal
	_add_sound_pick("crab_hit_metal", "sn_crabtron_metalhit01");
	_add_sound_pick("crab_hit_metal", "sn_crabtron_metalhit02");
	_add_sound_pick("crab_hit_metal", "sn_crabtron_metalhit03");
	_add_sound_pick("crab_hit_metal", "sn_crabtron_metalhit04");
	_add_sound_pick("crab_hit_metal", "sn_crabtron_metalhit05");
	_add_sound_pick("crab_hit_metal", "sn_crabtron_metalhit06");

	## Mynthos boss ##
	_add_sound_pick("mynthos_totemhurt", "sn_mynthos_totemhurt01");
	_add_sound_pick("mynthos_totemhurt", "sn_mynthos_totemhurt02");
	_add_sound_pick("mynthos_totemhurt", "sn_mynthos_totemhurt03");
	_add_sound_pick("mynthos_totemdeath", "sn_mynthos_totembreak01");
	_add_sound_pick("mynthos_totemdeath", "sn_mynthos_totembreak02");
	_add_sound_pick("mynthos_totemdeath", "sn_mynthos_totembreak03");

	## Padre of Bones boss ##
	_add_sound_pick("padre_minionhurt", "sn_mynthos_totemhurt01");
	_add_sound_pick("padre_minionhurt", "sn_mynthos_totemhurt02");
	_add_sound_pick("padre_minionhurt", "sn_mynthos_totemhurt03");
	_add_sound_pick("padre_miniondeath", "sn_mynthos_totembreak01");
	_add_sound_pick("padre_miniondeath", "sn_mynthos_totembreak02");
	_add_sound_pick("padre_miniondeath", "sn_mynthos_totembreak03");


	## Seagull ##
	_add_sound_pick("seagull_caw", "sn_wasteland_seagull01");
	_add_sound_pick("seagull_caw", "sn_wasteland_seagull02");
	_add_sound_pick("seagull_caw", "sn_wasteland_seagull03");
	_add_sound_pick("seagull_wingflap", "sn_wingflap01");
	_add_sound_pick("seagull_wingflap", "sn_wingflap02");
	_add_sound_pick("seagull_wingflap", "sn_wingflap03");

	## EXPLOSIONS ##
	## 0 is the lowest intensity explosion, 10 is the highest
	_add_sound_pick("explosion_generic_0", "sn_explosion_generic_00_01");
	_add_sound_pick("explosion_generic_0", "sn_explosion_generic_00_02");
	_add_sound_pick("explosion_generic_0", "sn_explosion_generic_00_03");
	_add_sound_pick("explosion_generic_1", "sn_explosion_generic_01_01");
	_add_sound_pick("explosion_generic_1", "sn_explosion_generic_01_02");
	_add_sound_pick("explosion_generic_1", "sn_explosion_generic_01_03");
	_add_sound_pick("explosion_generic_2", "sn_explosion_generic_02_01");
	_add_sound_pick("explosion_generic_2", "sn_explosion_generic_02_02");
	_add_sound_pick("explosion_generic_2", "sn_explosion_generic_02_03");
	_add_sound_pick("explosion_generic_3", "sn_explosion_generic_03_01");
	_add_sound_pick("explosion_generic_3", "sn_explosion_generic_03_02");
	_add_sound_pick("explosion_generic_3", "sn_explosion_generic_03_03");
	_add_sound_pick("explosion_generic_4", "sn_explosion_generic_04_01");
	_add_sound_pick("explosion_generic_4", "sn_explosion_generic_04_02");
	_add_sound_pick("explosion_generic_4", "sn_explosion_generic_04_03");
	_add_sound_pick("explosion_generic_5", "sn_explosion_generic_05_01");
	_add_sound_pick("explosion_generic_5", "sn_explosion_generic_05_02");
	_add_sound_pick("explosion_generic_5", "sn_explosion_generic_05_03");
	_add_sound_pick("explosion_generic_6", "sn_explosion_generic_06_01");
	_add_sound_pick("explosion_generic_6", "sn_explosion_generic_06_02");
	_add_sound_pick("explosion_generic_6", "sn_explosion_generic_06_03");
	_add_sound_pick("explosion_generic_7", "sn_explosion_generic_07_01");
	_add_sound_pick("explosion_generic_7", "sn_explosion_generic_07_02");
	_add_sound_pick("explosion_generic_7", "sn_explosion_generic_07_03");
	_add_sound_pick("explosion_generic_8", "sn_explosion_generic_08_01");
	_add_sound_pick("explosion_generic_8", "sn_explosion_generic_08_02");
	_add_sound_pick("explosion_generic_8", "sn_explosion_generic_08_03");
	_add_sound_pick("explosion_generic_9", "sn_explosion_generic_09_01");
	_add_sound_pick("explosion_generic_9", "sn_explosion_generic_09_02");
	_add_sound_pick("explosion_generic_9", "sn_explosion_generic_09_03");
	_add_sound_pick("explosion_generic_10", "sn_explosion_generic_10_01");
	_add_sound_pick("explosion_generic_10", "sn_explosion_generic_10_02");
	_add_sound_pick("explosion_generic_10", "sn_explosion_generic_10_03");

	_add_sound_pick("flintlock_fuse", "sn_debug_one");
	_add_sound_pick("musket_fuse", "sn_debug_two");

	## DESTRUCTIBLE SOUNDS ##
	_add_sound_pick("destructible_mtnpassJar", "sn_debug_one");

	## BULB SMASH ##
	_add_sound_pick("destructible_bustaBulb", "sn_bulb_smash01");
	_add_sound_pick("destructible_bustaBulb", "sn_bulb_smash02");
	_add_sound_pick("destructible_bustaBulb", "sn_bulb_smash03");
	_add_sound_pick("destructible_akiraBulb", "sn_bulb_smash01");
	_add_sound_pick("destructible_akiraBulb", "sn_bulb_smash02");
	_add_sound_pick("destructible_akiraBulb", "sn_bulb_smash03");
	_add_sound_pick("destructible_woodBarrel", "sn_wooden_barrel01");
	_add_sound_pick("destructible_woodBarrel", "sn_wooden_barrel02");
	_add_sound_pick("destructible_woodBarrel", "sn_wooden_barrel03");
	
	## INFO Unused sound that I want to use.
	_add_sound_pick("trashtalk", "sn_trashtalk2_01");
	_add_sound_pick("trashtalk", "sn_trashtalk2_02");
	_add_sound_pick("trashtalk", "sn_trashtalk2_03");
	_add_sound_pick("trashtalk", "sn_trashtalk2_04");
	_add_sound_pick("trashtalk", "sn_trashtalk2_05");
	
	# Damn
#endregion
	if debug_messages: print("_init_sound_picks() ended: ", 	Time.get_ticks_msec(), " msecs. - ", sound_pick.size(), " sound_pick entries" )
	
func _add_sound_pick(sound_key : String, sound_value : String):
	if not sound_pick.has(sound_key):
		# create key and init an empty array
		sound_pick[sound_key] = []
	sound_pick[sound_key].append( sound_value )
	
func set_volume( raw_value : float ): # 0 - 100
	raw_value = clampf(raw_value, 0, 100)
	B2_Config.sfx_gain_master = raw_value / 100
	for sound in sound_pool:
		sound.volume_db = linear_to_db( B2_Config.sfx_gain_master )

func get_volume() -> float:
	return B2_Config.sfx_gain_master

func _enter_tree() -> void:
	_init_sound_banks()
	_init_sound_picks()
	
func _ready():
	B2_Playerdata.gun_changed.connect( _play_gun_swap_sfx )
	for i in sound_pool_amount:
		sound_pool.append( 					AudioStreamPlayer.new() 	)
	if debug_messages: print( "Sound: sound_pool: x", sound_pool.size() ); print( "Sound: sound_bank entries: %s. sound_pick entries: %s." % [ sound_bank.size(), sound_pick.size() ] )

## Plays SFX when the player changes Weapons.
func _play_gun_swap_sfx() -> void:
	var wpn = B2_Gun.get_current_gun()
	## Tries to pick a specific swapsound. if it cant, play the default one.
	if wpn:
		play_pick( wpn.get_swap_sound() )
	else:
		play_pick( "hoopz_swapguns" ) ## "hoopz_swapguns" is the default is no sound exists

## used for Positional sounds. # Return the file name for a sound effect
func get_sound(soundID : String) -> String:
	if sound_bank.has(soundID):
		return sound_bank[soundID]
	elif sound_pick.has(soundID): ## Fallback to soundpick
		assert( not sound_pick[soundID].is_empty(), "It should not be empty, i think." )
		var soundVal : String = sound_pick[soundID].pick_random() # <- Important
		return get_sound(soundVal) ## NOTE We looping, bitch
	else:
		return ""
	
# Return the file name for a soundpick
func get_sound_pick(soundpickID : String) -> String:
	if sound_pick.has(soundpickID): ## Fallback to soundpick
		assert( not sound_pick[soundpickID].is_empty(), "It should not be empty, i think." )
		return sound_pick[soundpickID].pick_random() as String # <- Important
	else:
		# Sound not found
		return soundpickID
		
## stop the player from playing, emit a signal to force a graceful stop
## You can also do some fancy stuff, like fading aout the audio before stopping it.
func stop(sfx : AudioStreamPlayer, fade := false, fade_time := 0.0): 
	if sound_loop.has(sfx):
		sound_loop[sfx] = 0
	if fade:
		var fade_tween := create_tween()
		fade_tween.tween_property(sfx, "volume_db", linear_to_db(0.01), fade_time )
		await fade_tween.finished
	if sfx != null:
		sfx.finished.emit()

func play_pick(soundID : String, start_at := 0.0, priority := false, loops := 1, pitch := 1.0) -> AudioStreamPlayer:
	if sound_pick.has(soundID):
		assert( not sound_pick[soundID].is_empty(), "It should not be empty, i think." )
		var soundVal : String = sound_pick[soundID].pick_random() # <- Important
		return play(soundVal, start_at, priority, loops, pitch)
	else:
		push_warning("Invalid SoundID: ", soundID)
		return AudioStreamPlayer.new() # -1;
		
func play(soundID : String, start_at := 0.0, priority := false, loops := 1, pitch := 1.0) -> AudioStreamPlayer:
	if sound_bank.has(soundID):
		return queue(soundID, start_at, priority, loops, pitch)
		
	elif sound_pick.has(soundID): ## Fallback to soundpick
		assert( not sound_pick[soundID].is_empty(), "It should not be empty, i think." )
		var soundVal : String = sound_pick[soundID].pick_random() # <- Important
		return play(soundVal, start_at, priority, loops, pitch) ## NOTE We looping, bitch
		
	else: ## Invalid sound
		if soundID.is_empty():
			push_warning("B2_Sound: Empty SoundID called.")
		else:
			push_warning("Invalid SoundID: ", soundID)
		return AudioStreamPlayer.new() # -1;

func queue( soundID : String, start_at := 0.0, _priority := false, loops := 1, pitch := 1.0 ) -> AudioStreamPlayer:
	if sound_pool.is_empty():
		push_error("No audiostreeeeeeen on the pool. This is CRITICAL!")
		return AudioStreamPlayer.new()
	var sfx : AudioStreamPlayer = sound_pool.pop_back()
	var sound := load( sound_bank[soundID] )
	sfx.stream = sound
	sfx.name = soundID + "_" + str(randi())
	sfx.finished.connect( finished_playing.bind(sfx) )
	sfx.volume_db = linear_to_db( B2_Config.sfx_gain_master )
	sfx.pitch_scale = pitch
	## Loop Setup
	sound_loop[sfx] = loops
	
	add_child(sfx)
	sfx.play( start_at )
	return sfx

## Loop - Allow infinite looping SFX while changing rooms. for limited looping, use play()
func play_loop( soundID : String ):
	var audio_stream : AudioStreamOggVorbis = load( get_sound( soundID ) )
	audio_stream.loop = true
	audio_loop.volume_db = linear_to_db( B2_Config.sfx_gain_master * 0.75 )
	audio_loop.stream = audio_stream
	audio_loop.play()
	
func stop_loop():
	if audio_loop.playing:
		audio_loop.stop()
	else:
		push_warning("Nothing is playing. something may be wrong.")

func set_loop_volume( volume : float ):
	if volume > 1.0:
		push_warning("Volume out of range - %s - careful." % volume)
	audio_loop.volume_db = linear_to_db( volume )

func finished_playing( sfx : AudioStreamPlayer ):
	if sound_loop.has(sfx):
		sound_loop[sfx] -= 1
		if sound_loop[sfx] > 0:
			sfx.play()
			return
	sfx.finished.disconnect( finished_playing.bind(sfx) )
	remove_child( sfx )
	sound_pool.push_back( sfx )
