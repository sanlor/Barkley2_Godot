extends Resource
class_name Text

## NOTE This Resource replaces the TextProcessor() script 
# Also, check TextSpecial() for special effects

# This script is pretty important. It handles text replacement for the al bhed language, variable injections and name replacement.
# Its bitchin'.

# Text Colors
const textcolorMainquest 	:= Color8(255, 190, 40);
const textcolorSidequest 	:= Color8(140, 160, 255);
const textcolorKeyword 		:= Color8(110, 250, 150);
const textcolorRegular 		:= Color8(255, 255, 255);
const textcolorCurses 		:= Color8(255, 210, 210);
const textcolorNames 		:= Color8(200, 200, 255); 
const textcolorTime 		:= Color8(220, 220, 20); 
const textcolorFlavor 		:= Color8(255, 230, 255);
const textcolorEncounter 	:= Color8(255, 255, 150);
const textcolorQuote 		:= Color8(230, 255, 240);

const textcolorCuchulainn 	:= Color8(40, 90, 220);
const textcolorCyberdwarf 	:= Color8(255, 185, 80);

const textcolorHoopzBanter 	:= Color8(255, 255, 255);
const textcolorHoopzDamage 	:= Color8(255, 50, 100);
const textcolorHoopzCandy 	:= Color8(100, 50, 255);

## Important function for text translation and parsing.
static func pr( text : String = "You forgot to add text, jackass." ) -> String:
	if B2_Config.AlBhed:
		
		var out_text = "";
		var length = text.length()
		
		# Go through each character and change it if need be.
		for i in length:
			# Grab the current char.
			var my_char = text[i]
			# Check if the letter is capital
			var is_upper := false
			if my_char == my_char.to_upper():
				is_upper = true
			my_char = my_char.to_lower()
			# The character to output to the string, default as just the char.
			var out_char = my_char;

			match my_char:
				"a":
					out_char = "y";
				"b":
					out_char = "p";
				"c":
					out_char = "l";
				"d":
					out_char = "t";
				"e":
					out_char = "a";
				"f":
					out_char = "v";
				"g":
					out_char = "k";
				"h":
					out_char = "r";
				"i":
					out_char = "e";
				"j":
					out_char = "z";
				"k":
					out_char = "g";
				"l":
					out_char = "m";
				"m":
					out_char = "s";
				"n":
					out_char = "h";
				"o":
					out_char = "u";
				"p":
					out_char = "b";
				"q":
					out_char = "x";
				"r":
					out_char = "n";
				"s":
					out_char = "c";
				"t":
					out_char = "d";
				"u":
					out_char = "i";
				"v":
					out_char = "j";
				"w":
					out_char = "f";
				"x":
					out_char = "q";
				"y":
					out_char = "o";
				"z":
					out_char = "w";
				_:
					out_char = my_char
		
			# Add the character to the out string.
			if is_upper:
				out_text += out_char.to_upper()
			else:
				out_text += out_char;
			

		return out_text;
		
	else:
		## WARNING Albhed doesnt work with this. TextSpecial() has a good sollution.
		var new_text = text.replace("#", "\n") # <-  Used on the CC mostly.
		
		new_text = new_text.replace("/'", '"') # Add support for " character.
		
		new_text = new_text.replace("`mq`", "[color=#%s]" % textcolorMainquest.to_html() )
		new_text = new_text.replace("`sq`", "[color=#%s]" % textcolorSidequest.to_html() )
		new_text = new_text.replace("`kw`", "[color=#%s]" % textcolorKeyword.to_html() )
		new_text = new_text.replace("`rt`", "[/color]")
		
		new_text = new_text.replace("`w0`", "[/wave]")
		new_text = new_text.replace("`w1`", "[wave amp=30.0 freq=5.0 connected=0]")
		new_text = new_text.replace("`w2`", "[wave amp=50.0 freq=10.0 connected=0]")
		
		new_text = new_text.replace("`s0`", "[/shake]")
		new_text = new_text.replace("`s1`", "[shake rate=20.0 level=8 connected=1]") # The level requires some adjustments.
		
		## Mess around with player name
		## Replace variable P_NAME with actuall player name. Player name can be set on the CC. Defaults to X11JAM9.
		new_text = new_text.replace("P_NAME_F", B2_Playerdata.Quest("playerNameFull", null, "playerNameFull") )
		new_text = new_text.replace("P_NAME_S", B2_Playerdata.Quest("playerNameShort", null, "playerNameShort") )
		new_text = new_text.replace("P_NAME", 	B2_Playerdata.Quest("playerName", null, "playerName") )
		
		return new_text

## Man, this game gives me no breaks, huh.
## sometimes, text have secret "variables" inside the text. this check replaces the "@variable@" with the actual variable.
# check Cinema() line 663
static func qst( text : String = "You forgot to add text, jackass." ) -> String:
	# I tried to code my own function, but copying the original function is way easier and it works great.
	# Forget that, I basically copied the original code and used some built in godot functions.
	while text.contains("@"):
		if text.count("@") == 1: 
			## Should never only be one @.
			push_error("Incorrect amount of @s.")
			return "@ PARSE ERROR"
		
		var first_at 		:= text.find( "@", 0 )
		var second_at 		:= text.find( "@", first_at + 1 )
		var str_var 		:= text.get_slice( "@", 1 ).strip_edges() # original text
		var parsed_str_var 	:= "INVALID"
		
		# Get the actual value from the newly created B2_Database. Its a "database" made for B2!
		if str_var.begins_with("money_"):
			str_var = str_var.trim_prefix("money_")
			parsed_str_var = str( B2_Database.money.get(str_var, 99999) )
			
		elif str_var.begins_with("duergar_"):
			pass # TODO
		elif str_var.begins_with("time_"):
			pass # TODO
		elif str_var.begins_with("item_"):
			pass # TODO
		elif str_var.contains("note"):
			pass # TODO
		elif str_var.contains("shop"):
			pass # TODO
		elif str_var.contains("gunsbag"):
			pass # TODO
		else:
			# Cinema() line 678
			# qstStr = string(scr_quest_get_state(_qstNam));
			pass # TODO

		text = text.erase( first_at, (second_at - first_at) + 1 )
		text = text.insert( first_at, parsed_str_var )
		## INCOMPLETE
		
	return text


## Function return the index for each space (" ") in the text.
static func get_delays( text : String ) -> PackedInt32Array:
	var delay_array := PackedInt32Array()
	var search_point := 0
	for c in text.count("_"):
		var delay := text.find("_", search_point)
		## NOTE the delay_array.size() assumes that the "_" is going to be removed after.
		delay_array.append( delay - delay_array.size() ) 
		# result example without size(): 	Text delays: [191, 193, 195, 197, 199, 201, 203, 205, 207, 209, 211]
		# result example with size(): 		Text delays: [191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201]
		search_point = delay + 1
	
	return delay_array
