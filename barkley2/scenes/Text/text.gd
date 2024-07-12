extends Resource
class_name Text

## NOTE This Resource replaces the TextProcessor() script 

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
		var new_text = text.replace("#", "\n")
		
		return new_text
