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
const dnetColorPip_0 := Color.GREEN; # Regular user
const dnetColorPip_1 := Color.WHITE; # Primo  - DOES NOT HAVE PIP COLOR, says text PRIMO
const dnetColorPip_2 := Color.RED;   # Moderator
const dnetColorPip_3 := Color.WHITE; # Banned - DOES NOT HAVE PIP COLOR, says text BANNED

## Time - Certain messages only appear at certain times.
static var current_time := 0

static func set_time( time : float ) -> void:
	B2_Config.set_user_save_data("clock.time", time)

static func get_time_str() -> String:
	@warning_ignore("integer_division")
	return str( get_time_hour() / 24 ).pad_zeros(2) + " Days, " + str( get_time_hour() % 24 ).pad_zeros(2) + ":" + str( get_time_minute() ).pad_zeros(2)

static func get_time_hour() -> int:
	@warning_ignore("integer_division")
	return int( B2_Config.get_user_save_data("clock.time", 0.0) ) / 60
	
static func get_time_minute() -> int:
	return int( B2_Config.get_user_save_data("clock.time", 0.0) ) % 60
