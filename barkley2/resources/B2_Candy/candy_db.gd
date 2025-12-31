extends Resource
class_name B2_Candy

## Define candies in order of weakest to strongest Drop value
## TODO Decide if this should be a JSON resource.
# no, fuck JSON.

enum {SUB,DROP,SMELT,MARQUEE,DESCRIPTION,FLAVOR}
const CANDY_LIST := {
## 	Name			  Sub  Drop Smelt 	Marquee    Utility Station Description					Flavor Description
	"Butterscotch":   [00, 000, 010, 	"CHOMP!",  "+25 HP",                                  	"Bland as hell like Grandpappy liked."],
	"Chickenfry Dew": [02, 040, 015, 	"BITE!",   "+40 HP, +2 Might for 60",                 	"From the first one. Decent snack. Wet."],
	"Sweet Sweat":    [03, 050, 010, 	"SLURP!",  "Remove all Ailments",                     	"The sweat of a sweet. Cures what ails you."],
	"Black Licorice": [04, 060, 005, 	"GOMP!",   "Ailment Immunity for 60 seconds",         	"Tastes like anise. So bad, nothing else matters."],
	"Candy Corn":     [05, 070, 025, 	"MASH!",   "+100 Element Resistance for 30 seconds",  	"Traditionally consumed by techno-sherpas and their kin. Fortifies you from the elements."],
	"Ecto Poppers":   [06, 080, 020, 	"POP!",    "-50 HP, +10 GLAMP for 60 seconds",        	"Exxxtreme Gamerfuel. Berzerked metabolism begins to break down all stomach contents and liver."],
	"Choco-mallows":  [07, 999, 050, 	"MUNCH!",  "+100% HP, +5 GLAMP for 20 seconds",      	"Clispaeth's Gift to Dwarfs. The best candy on Necron 7, 4613 years running."],
	"Wilmer's Neue":  [01, 999, 015, 	"CRUNCH!", "+100 HP, +5 GUTS for 10 seconds",        	"Makes the weak strong and the feeble emboldened. A unique and arcane recipe."],
	}
	
## Effects of candy, can add multiple
enum {EFFECT,COST,TIME}
const CANDY_EFFECT := {
	# Butterscotch
	"Butterscotch": 		[	["heal", 25]	],
	# Wilmer's Neue
	"Wilmer's Neue": 		[	[	"heal", 100],	["gutsBoost", 5, 10]	],
	# Chickenfry Dew
	"Chickenfry Dew": 		[	[	"heal", 40], 	["mightBoost", 2, 60] 	 ],
	#  Black Licorice
	# TODO: ailment immunity
	"Black Licorice": 		[	[	"heal", 100] ],
	# Candy Corn
	# TODO: element resistance
	"Candy Corn": 			[	["heal", 100] ],
	# Sweet Sweat
	"Sweet Sweat": 			[	[	"heal", 100], 	["antidote", 0]	],
	# Ectopoppers
	"Ecto Poppers": 		[	[	"heal", -50], 	["glampBoost", 10, 60]	],
	# Choco-mallows
	"Choco-mallows": 		[	[	"heal", 999], 	["glampBoost", 5, 20]	],
	}

static func reset() -> void:
	B2_Config.set_user_save_data("player.schematics.candy", []);
	
	
static func gain_candy( candy_name : String ) -> void:
	if CANDY_LIST.has( candy_name ):
		if B2_Jerkin.pockets_free() > 0:
			## DEPRECATED
			#var my_items : Array = B2_Config.get_user_save_data("player.items.has", [])
			#my_items.append( candy_name )
			##my_items.sort() ## is this necessary?
			#B2_Config.set_user_save_data("player.items.has", my_items )
			B2_Jerkin.add_pocket_content( candy_name ) ## FIXME
	
## DEPRECATED
static func remove_candy( candy_name : String ) -> void:
	if CANDY_LIST.has( candy_name ):
		var my_items : Array = B2_Config.get_user_save_data("player.items.has", [])
		if my_items.has( candy_name ):
			my_items.erase( candy_name )
			#my_items.sort() ## is this necessary?
			B2_Config.set_user_save_data("player.items.has", my_items )
		else:
			push_error("Tried to remove a candy that the player does not have.")
	
# scr_items_candy_use_fromMap
static func use_candy( candy_name : String ) -> void:
	var item_data : Array = B2_Candy.get_candy_effect( candy_name )
	B2_Sound.play( "hoopz_crunchcandy" )
	for e in item_data:
		match e[B2_Candy.EFFECT]:
			## TODO add other effects.
			"heal":
				B2_Screen.display_item_effect( candy_name, str( e[B2_Candy.COST] ) )
				B2_Playerdata.player_stats.increase_hp( e[B2_Candy.COST] )
			"healOverTime":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"antidote":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"showText":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"speedBoost":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"gutsBoost":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"luckBoost":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"acroBoost":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"mightBoost":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"pietyBoost":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"glampBoost":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			"scrollWeapon":
				push_warning("Item effect not set: ", e[B2_Candy.EFFECT])
			_:
				push_warning("Unhandled item effect: ", e[B2_Candy.EFFECT] )
	
	## TODO add candy effects.
	pass
	
static func get_candy( candy_name : String ) -> Dictionary:
	if CANDY_LIST.has( candy_name ):
		var candy := {
			"sub": 		int(CANDY_LIST.get( candy_name )[SUB]),
			"drop": 	int(CANDY_LIST.get( candy_name )[DROP]),
			"smelt": 	int(CANDY_LIST.get( candy_name )[SMELT]),
			"marquee": 	str(CANDY_LIST.get( candy_name )[MARQUEE]),
			"utility": 	str(CANDY_LIST.get( candy_name )[DESCRIPTION]),
			"flavor": 	str(CANDY_LIST.get( candy_name )[FLAVOR]),
		}
		return candy
	else:
		return {}
		
static func get_candy_effect( candy_name : String ) -> Array:
	return CANDY_EFFECT.get(candy_name, [])
	
static func list_recipes() -> Array:
	return B2_Config.get_user_save_data( "player.schematics.candy", [] ) # Returns array of recipes the player has.
	
static func has_recipe( recipe : String ) -> bool:
	return B2_Config.get_user_save_data( "player.schematics.candy", [] ).has(recipe) # Returns true if you have the recipe
	
static func add_candy_recipe( candy_name : String ) -> void:
	if CANDY_LIST.has( candy_name ):
		if not has_recipe( candy_name ):
			var my_recipe : Array = list_recipes()
			my_recipe.append( candy_name )
			print_rich("[color=orange]Recipe %s added.[/color]")
			B2_Config.set_user_save_data( "player.schematics.candy", my_recipe )
		else:
			push_error("Tried to add a recipe that was already owned (%s)." % candy_name)
	else:
		push_error("Tried to gain an invalid recipe (%s)." % candy_name)
	
static func remove_candy_recipe( candy_name : String ) -> void:
	if CANDY_LIST.has( candy_name ):
		if not has_recipe( candy_name ):
			var my_recipe : Array = list_recipes()
			my_recipe.erase( candy_name )
			print_rich("[color=orange]Recipe %s removed.[/color]")
			B2_Config.set_user_save_data( "player.schematics.candy", my_recipe )
		else:
			push_error("Tried to remove a recipe that wasnt already owned (%s)." % candy_name)
	else:
		push_error("Tried to remove an invalid recipe (%s)." % candy_name)
