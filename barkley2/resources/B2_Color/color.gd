## Control some color conversion between GMS color and Godot color.
# Stuff that were on B2_Gamedata was split into B2_Portrait and B2_Color

extends RefCounted
class_name B2_Color

# Gamemaker Color list. check https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Drawing/Colour_And_Alpha/Colour_And_Alpha.htm
const GAMEMAKER_COLORS := {
	"c_aqua":	  	16776960,
	"c_black": 	  	0,
	"c_blue":	  	16711680,
	"c_dkgray":   	4210752,
	"c_fuchsia":  	16711935,
	"c_gray": 	  	8421504,
	"c_green": 	  	32768,
	"c_lime": 	  	65280,
	"c_ltgray":   	12632256,
	"c_maroon":   	128,
	"c_navy": 	  	8388608,
	"c_olive": 	  	32896,
	"c_orange":   	4235519,
	"c_purple":   	8388736,
	"c_red": 	  	255,
	"c_silver": 	12632256,
	"c_teal": 	  	8421376,
	"c_white": 	  	16777215,
	"c_yellow": 	65535,
}

# Color stuff: GMS constants
const C_BIO		:= Color8(27, 255, 1)
const C_COSMIC	:= Color8(207, 83, 0)
const C_CYBER	:= Color8(84, 186, 254)
const C_MENTAL	:= Color8(226, 154, 138)
const C_ZAUBER	:= Color8(211, 42, 222)

static func gml_color_to_godot_color( color_name ) -> Color:
	return just_convert_gamemaker_color_to_hex_already( GAMEMAKER_COLORS.get( color_name, 16777215 ) )
	
static func just_convert_gamemaker_color_to_hex_already( stupid_color : int ) -> Color:
	# check https://marketplace.gamemaker.io/assets/2074/number-conversion-and-other
	## Shit, I just got it!!! Gamemaker uses a weird decimal sistem to set color!!!
	# check https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Drawing/Colour_And_Alpha/Colour_And_Alpha.htm#
	# c_lime 	  	INT 65280 -> HEX 0x00FF00 ( 00 B - FF G - 00 R )
	# NOTE 20/11/25 I'm still so proud of myself for figuring it all by myself.
	var my_col := Color.WHITE
	
	var stupid_hex_color := String.num_int64( stupid_color, 16, true).lpad(6,"0")
	var r := stupid_hex_color.substr(4, 1)
	var g := stupid_hex_color.substr(2, 1)
	var b := stupid_hex_color.substr(0, 1)
	
	if str(r + g + b).is_valid_hex_number():		my_col = Color( r + g + b )
	else:											push_warning("Invalid color :" + r + g + b)
	return my_col
