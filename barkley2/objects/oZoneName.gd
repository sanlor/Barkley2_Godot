#extends CanvasLayer
extends Control

## Controls the Zone Text display when changing areas

## Setup ##
var zone 		:= ""
var flavor 		:= ""
var z_color 		:= Color.WHITE
var f_color 		:= Color.LIGHT_GRAY

## Old Vars, no idea how they are used
#var zone = "";
#var zoneLast = "";
#var flavorLast = "";
#var yPos = 16;
#var alpha = 0;
#var alpha2 = 0;
#var alpha_goal = 1;
#var alpha2_goal = 1;
#var start = false;
#var ending = false;
#var zone_name = "Zone"; ## Original var name was "name".
#var flavor = "Flavor";
#var timer_ending = 0;
#var timer_start = 0;
#var timer_flavor = 0;

@onready var zone_container: 	PanelContainer 	= $zone_name/zone_container
@onready var zone_label: 		Label 			= $zone_name/zone_container/zone_label
@onready var flavor_label: 		Label 			= $zone_name/flavor_label


## Room Start

## Setup ##
## As a failsafe against this text persisting for any reason, alarm 0 is set for about 15 seconds from room start. 
## It forcibly sets this object back to invisible. 15 seconds is only slightly longer than the text lasts for naturally.
# alarm[0] = 450; # NOTE Maybe is not needed

# Fill zone and flavor variables with data
# event_user(0); ## FIXME THis need to listen to a signal when a room changes, and call zone_data( area : String) 
# if (zoneLast == zone && flavorLast == flavor) { visible = 0; exit; } ## NOTE If its the same zone, do nothing

# Exceptions to the rule #
#if room = r_fct_factoryOutpost01 and Quest("tutorialProgress") <= 11 then  FIXME Quest Autoload not translated
	#visible = false;  FIXME Quest Autoload not translated

# visible = 1; 

func _ready():
	# if quest var is not set, do not show the zone name (used on the tutorial, i think).
	if B2_Playerdata.Quest("zoneVisible") == 0: ## FIXME Quest Autoload not translated
		## Now it works!
		queue_free()
	
	# Zone not set.
	if zone == "" and flavor == "":
		queue_free()
		
	# Do not show the same name all the time, only when changing zones or loading the game.
	if zone == B2_Gamedata.last_zone_name:
		queue_free()
		
	B2_Gamedata.last_zone_name = zone
		
	#layer = B2_Config.NOTICE_LAYER
	z_index = 4096
		
	# Set texts
	zone_label.text 		= Text.pr(zone)
	flavor_label.text 		= Text.pr(flavor)
	
	# align
	zone_container.set_anchors_preset(Control.PRESET_CENTER_TOP)
	flavor_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	zone_container.position.y 	= 16.0
	flavor_label.position.y 	= 38.0
	
	# get ready for tweening
	zone_label.modulate 		= z_color
	zone_container.modulate.a 	= 0.0
	flavor_label.modulate		= f_color
	flavor_label.modulate.a 	= 0.0
		
	display_text()

## DATA ## ATTENTION ## Migrate this to a JSON file or a resource.
## ^^^ Fuck you, can't tell me what to do!
func zone_data( room_name : String):
	var area := ""
	
	if room_name == "r_est_industrialZone01":
		zone = "The Social";
		flavor = "Sanctuary for the wary and weary";
		return
	
	if room_name.begins_with("r_") and room_name.count("_", 0, 6) >= 2:
		area = room_name.get_slice( "_", 1 ) # r_tnn_residentialDistrict01 > tnn
		
		match area:
			"tnn":
				zone = "Tir na nOg";
				flavor = "Forlorn Cyberghetto";
			"sw1", "sw2": # equivalent of "or"
				zone = "Sewers of Nog";
				flavor = "The dankness is palpatable ...";
			"wst":
				zone = "The Westelands";
				flavor = "Junk and gunk, west of the Eastelands";
			"est":
				zone = "The Eastelands";
				flavor = "Trash and debris, east of the Westelands";
			"fct":
				if room_name.contains("biotek"): 
					zone = "Big Bad Wolf & Benjamin Biotek";
					flavor = "Hmm... I think something's off about this place...";
				else:
					zone = "Power Plant"; ## FIXME
					flavor = "The source of all juice"; ## FIXME
			"pdt":
				zone = "Ys-Kolob";
				flavor = "Ethnic melting pot";
			"dz2":
				zone = "Al-Akihabara";
				flavor = "Parched throats amidst the sands";
			"swp":
				zone = "Swamps";
				flavor = "*Sniff* *Sniff* Hmm... a dank smell...";
			"mtn":
				zone = "Mountainpass";
				flavor = "Check out these vistas";
			"gil":
				zone = "Gilbert's Peek";
				flavor = "Mysteriouse holy grounds";
			"pea":
				zone = "Gilbert's Peak";
				flavor = "Check out the peak";
			"bct":
				zone = "Braincity";
				flavor = "Cyberhell";
			"min":
				zone = "Mines";
				flavor = "Rubies and gemstones await...";
			"tri":
				zone = "The Bustling Metropolis of Triskelion";
				flavor = "Watch out for falling meteors (at the bazaar...)";
			"ice":
				zone = "Frigid Inskirts";
				flavor = "Don't catch a cold...";
			## DEBUG
			"air":
				zone = "A.I. Ruins";
				flavor = "A.K.A %s." % ["The Debug zone", "The Discount Backrooms", "The Wrong-Map-Loaded Room"].pick_random()
				
	
func display_text(): ## TODO actuall display text, wait and then fade away
	## TODO actually handle the player dying. vvvvvv
	#if (instance_exists(o_hoopz_death_grayscale)) exit;
	
	if B2_Playerdata.Quest("zoneVisible") == 0:
		queue_free()
		
	var tween := create_tween()
	
	tween.tween_interval( 1.0 )
	tween.tween_property(zone_container, "modulate:a", 1.0, 0.5)
	tween.tween_interval( 1.0 )
	tween.tween_property(flavor_label, "modulate:a", 1.0, 1.0)
	tween.tween_interval( 4.5 )
	tween.tween_property(flavor_label, "modulate:a", 0.0, 1.5)
	tween.parallel().tween_property(zone_container, "modulate:a", 0.0, 1.5)
	
	tween.tween_callback( queue_free )
