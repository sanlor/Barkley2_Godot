extends RefCounted
class_name B2_DNET

## Its time.
# THis is very decoupled from the game. Might release it as a standalone app.
# Check Dnet(), o_dnet_control and o_dnet_registration_boot, o_dnet_registration

## o_dnet_registration_boot
const MEMORY_CHECK_GOAL := 70656

const dwarfnet_color_0 := Color8(0, 80, 80);
const dwarfnet_color_1 := Color8(0, 255, 255);

## Color of the post body
const dnetColorPostMod := Color.GREEN;
const dnetColorPostReg : Color = lerp( Color.AQUA, Color.GRAY, 0.66 ) #merge_color(c_aqua, c_gray, 0.66);
const dnetColorPostPre := Color.ORANGE;
const dnetColorPostBan := Color.GRAY;

## Color of the poster's name
const dnetColorNameMod := Color.LIME;
const dnetColorNameReg : Color = lerp( Color.AQUA, Color.GRAY, 0.33 ) # merge_color(c_aqua, c_gray, 0.33);; # c_aqua;
const dnetColorNamePre := Color.YELLOW; # primo member
const dnetColorNameBan := Color.DARK_GRAY;

## Thread colors
const dentColorThreadLocked := Color.GRAY;
const dentColorThreadNormal := Color.WHITE;
const dentColorThreadSticky := Color.YELLOW;

## Pip colors
const dnetColorPip := [
	Color.GREEN, # Regular user
	Color.WHITE, # Primo  - DOES NOT HAVE PIP COLOR, says text PRIMO
	Color.RED,   # Moderator
	Color.WHITE # Banned - DOES NOT HAVE PIP COLOR, says text BANNED
	]
## Time - Certain messages only appear at certain times.
static var current_time := 0

static func Store(key : String, value = null, default = 0):
	# if value is not found, return "default"
	var questpath = "dnet.vars." + key;
	
	if value == null:
		var _key_value = B2_Config.get_user_save_data(questpath)
		if _key_value == null:
			return default
		else:
			return _key_value
	else:
		B2_Config.set_user_save_data(questpath, value)
		return true

## Forget minutes, focus on hours
static func time_before( time : String ) -> bool:
	var hour 		:= int( time.get_slice(":",0) )
	
	if round( B2_ClockTime.time_get() ) <= hour:
		return true
	return false
	
## Forget minutes, focus on hours
static func time_after( time : String ) -> bool:
	#print(( B2_ClockTime.time_get() ))
	var hour 		:= int( time.get_slice(":",0) )
	if roundi( B2_ClockTime.time_get() ) >= hour:
		return true
			
	return false

## FUCK THIS! FUCK ALL OF THIS.
static func get_time_hour() -> int:
	return roundi( B2_ClockTime.time_gate() )
