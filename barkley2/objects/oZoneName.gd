extends RichTextLabel

## Controls the Zone Text display when changing areas

## Setup ##
var zone = "";
var zoneLast = "";
var flavorLast = "";

var yPos = 16;
var alpha = 0;
var alpha2 = 0;
var alpha_goal = 1;
var alpha2_goal = 1;
var start = false;
var ending = false;
var zone_name = "Zone"; ## Original var name was "name".
var flavor = "Flavor";

var timer_ending = 0;
var timer_start = 0;
var timer_flavor = 0;

## Room Start

## Setup ##
## As a failsafe against this text persisting for any reason, alarm 0 is set for about 15 seconds from room start. 
## It forcibly sets this object back to invisible. 15 seconds is only slightly longer than the text lasts for naturally.
# alarm[0] = 450; # NOTE Maybe is not needed

# if (Quest("zoneVisible") == 0) exit; FIXME Quest Autoload not translated

# Fill zone and flavor variables with data
# event_user(0); ## FIXME THis need to listen to a signal when a room changes, and call zone_data( area : String) 
# if (zoneLast == zone && flavorLast == flavor) { visible = 0; exit; } ## NOTE If its the same zone, do nothing

# Exceptions to the rule #
#if room = r_fct_factoryOutpost01 and Quest("tutorialProgress") <= 11 then  FIXME Quest Autoload not translated
	#visible = false;  FIXME Quest Autoload not translated

# visible = 1; 

func _ready():
	timer_ending = 60
	timer_start = 5
	timer_flavor = 15

	zoneLast = zone
	flavorLast = flavor

	alpha_goal = 1
	alpha2_goal = 1
	if zone == "":
		visible = false

## DATA ## ATTENTION ## Migrate this to a JSON file or a resource.
func zone_data( area : String):
	match area:
		"tnn":
			zone = "Tir na nOg";
			flavor = "Forlorn Cyberghetto";
		"sw1", "sw2": # equivalent of "or"
			zone = "Sewers of Nog";
			flavor = "The dankness is palpatable ...";
		"r_est_industrialZone01":
			zone = "The Social";
			flavor = "Sanctuary for the wary and weary";
		"wst":
			zone = "The Westelands";
			flavor = "Junk and gunk, west of the Eastelands";
		"est":
			zone = "The Eastelands";
			flavor = "Trash and debris, east of the Westelands";
		"fct":
   # if (string_count("biotek", nam) > 0) ## NOTE No idea what this would be used
			zone = "Big Bad Wolf & Benjamin Biotek";
			flavor = "Hmm... I think something's off about this place...";
		# ???? ## FIXME
			#zone = "Power Plant"; ## FIXME
			#flavor = "The source of all juice"; ## FIXME
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

func display_text(): ## TODO actuall display text, wait and then fade away
	#// Draw text //
	#if (instance_exists(o_hoopz_death_grayscale)) exit;
	#if (Quest("zoneVisible") == 0) exit;
	#if (zone == "") exit;
	#draw_set_alpha(alpha);
	#scr_font(global.fn_1, c_white, 1, 1);
	#draw_sprite(s_effect_zonename_backdrop, 0, view_xview + 192 - string_width(zone) / 2, view_yview + 23);
	#draw_sprite(s_effect_zonename_backdrop, 2, view_xview + 192 + string_width(zone) / 2, view_yview + 23);
	#for (i=0; i<string_width(zone)+1; i+=1;)
	#draw_sprite(s_effect_zonename_backdrop, 1, view_xview + 192 - string_width(zone) / 2 + i, view_yview + 23);
	#draw_text(view_xview + 192, view_yview + 24, zone);
	#draw_set_alpha(alpha2 * 0.8);
	#draw_set_font(global.fn_2);
	#draw_text(view_xview + 192, view_yview + 44, flavor);
	#draw_set_halign(fa_left);
	#draw_set_valign(fa_top);
	#draw_set_alpha(1);
	pass
