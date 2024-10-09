extends Resource
class_name Text

## NOTE This Resource replaces the TextProcessor() script 
# Also, check TextSpecial() for special effects

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
		var new_text = text.replace("#", "\n")
		
		new_text = new_text.replace("`mq`", "[color=#%s]" % textcolorMainquest.to_html() )
		new_text = new_text.replace("`sq`", "[color=#%s]" % textcolorSidequest.to_html() )
		new_text = new_text.replace("`kw`", "[color=#%s]" % textcolorKeyword.to_html() )
		new_text = new_text.replace("`rt`", "[/color]")
		
		new_text = new_text.replace("`w0`", "[/wave]")
		new_text = new_text.replace("`w1`", "[wave amp=30.0 freq=5.0 connected=0]")
		new_text = new_text.replace("`w2`", "[wave amp=50.0 freq=10.0 connected=0]")
		
		new_text = new_text.replace("`s0`", "[/shake]")
		new_text = new_text.replace("`s1`", "[shake rate=20.0 level=2 connected=0]")
		
		return new_text

## Function return the index for each space (" ") in the text.
static func get_delays( text : String ) -> PackedInt32Array:
	var delay_array := PackedInt32Array()
	var search_point := 0
	for c in text.count("_"):
		var delay := text.find("_", search_point)
		delay_array.append( delay )
		search_point = delay
	
	return delay_array
