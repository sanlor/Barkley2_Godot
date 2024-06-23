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
if room = r_fct_factoryOutpost01 and Quest("tutorialProgress") <= 11 then 
	{
	visible = false;
	exit;
	}

visible = 1;

timer_ending = 60;
timer_start = 5;
timer_flavor = 15;

zoneLast = zone;
flavorLast = flavor;

alpha_goal = 1;
alpha2_goal = 1;
if (zone == "") visible = 0;

## DATA ## ATTENTION ## Migrate this to a JSON file or a resource.
func zone_data( area : String):
	match area:
		"tnn":
			zone = "Tir na nOg";
			flavor = "Forlorn Cyberghetto";
		"sw1":
		"sw2":
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

if (area == "dz2")
{
	zone = "Al-Akihabara";
	flavor = "Parched throats amidst the sands";
	exit;
}

if (area == "swp")
{
	zone = "Swamps";
	flavor = "*Sniff* *Sniff* Hmm... a dank smell...";
	exit;
}

if (area == "mtn")
{
	zone = "Mountainpass";
	flavor = "Check out these vistas";
	exit;
}

if (area == "gil")
{
	zone = "Gilbert's Peek";
	flavor = "Mysteriouse holy grounds";
	exit;
}

if (area == "pea")
{
	zone = "Gilbert's Peak";
	flavor = "Check out the peak";
	exit;
}

if (area == "bct")
{
	zone = "Braincity";
	flavor = "Cyberhell";
	exit;
}

if (area == "min")
{
	zone = "Mines";
	flavor = "Rubies and gemstones await...";
	exit;
}

if (area == "tri")
{
	zone = "The Bustling Metropolis of Triskelion";
	flavor = "Watch out for falling meteors (at the bazaar...)";
	exit;
}   

if (area == "ice")
{
	zone = "Frigid Inskirts";
	flavor = "Don't catch a cold...";
	exit;
}   
