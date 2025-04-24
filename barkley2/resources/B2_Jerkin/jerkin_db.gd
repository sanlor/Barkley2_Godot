extends Resource
class_name B2_Jerkin

## Manages jerkin stuff
# Unrelated, but check this out -> https://www.youtube.com/watch?v=WAYyMrPUGAo
# Sometimes I wonder why im doing this. Will I ever finish it?

enum {SUB,PKT,WGT,FSH,NORMAL,BIO,CYBER,MENTAL,KOSMIC,ZAUBER,DESCRIPTION}
const JERKIN_LIST := {
##	Name                   Sub 	Pkt Wgt Fsh Normal  Bio     Cyber   Mental  Kosmic  Zauber  Description
	"Cornhusk Jerkin":     [00, 04, 04, 0,  "+020", "+030", "-020", "+010", "+000", "-050", "Protective outer covering of a once-anointed cob of maize."], ## This husk was removed at the peak time, when the endosperm was in the 'milk stage'.  This means you can be guaranteed a firmer defense against piercing weapons.
	"Bottlecap Jerkin":    [01, 03, 03, 0,  "+030", "+030", "+030", "+030", "+030", "+030", "Gleaming cuirass of discarded bottlecaps. Gives protection."],
	"Lead Jerkin":         [02, 02, 20, 0,  "+100", "+100", "+100", "+100", "+100", "+100", "Can take a lickin' and keep on tickin'. Extremely heavy."],
	"Eggcrate Jerkin":     [03, 08, 02, 0,  "-025", "+000", "+050", "+000", "+000", "+000", "Carelessly discarded packing material of great value."],
	"Monofilament Jerkin": [04, 05, 06, 0,  "+100", "+100", "+000", "-050", "+000", "-050", "A hectare of used fishing line gleaned from the sewers."],
	"Booty Jerkin":        [05, 06, 06, 0,  "+050", "-050", "+050", "-050", "+050", "-050", "Has ample room for even the largest of applebottoms."],
	"Vestal Jerkin":       [06, 04, 03, 0,  "+000", "+075", "+075", "+075", "+075", "+075", "Renowned for it's protection against elements."],
	"Bisphenol A Jerkin":  [07, 08, 08, 0,  "+100", "+025", "+025", "+025", "-100", "+025", "Not much is known about this jerkin."],
	"Kangaroo Skin":       [08, 08, 06, 0,  "+000", "+000", "+000", "+000", "+000", "+000", "This Kangaroo Skin is rimmed with pockets."],
	"Gilbert's Pique":     [09, 04, 03, 0,  "+020", "+010", "+010", "+010", "+100", "+010", "Jerkin worn by the legendary Gilbert."],
	"Bespoke Jerkin":      [10, 05, 06, 0,  "+030", "-030", "+050", "+010", "+000", "-100", "A jerkin all to oneself."],
	}
	
static func reset() -> void:
	B2_Config.set_user_save_data("player.jerkins.has", []); 		# ds_list of jerkins the player has
	B2_Config.set_user_save_data("player.jerkins.current", ""); 	# Hoopz current jerkin
	
static func get_current_jerkin() -> String:
	return B2_Config.get_user_save_data("player.jerkins.current")
	
static func list_jerkin() -> Array:
	return B2_Config.get_user_save_data("player.jerkins.has", [])
	
static func has_jerkin( jerkin : String ) -> bool:
	return B2_Config.get_user_save_data("player.jerkins.has", []).has(jerkin)
	
static func get_jerkin_stats( jerkin := "" ) -> Dictionary:
	var stat := {
		"Pkt": 			0,
		"Wgt": 			0,
		"Fsh": 			0,
		"Normal": 		0, 
		"Bio": 			0,    
		"Cyber": 		0,  
		"Mental": 		0, 
		"Kosmic": 		0, 
		"Zauber": 		0, 
		"Description": 	"",
		}
	if jerkin == "": ## Defaults to the current jerkin.
		if get_current_jerkin() != "":
			stat["Pkt"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ PKT ] )
			stat["Wgt"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ WGT ] )
			stat["Fsh"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ FSH ] )
			stat["Normal"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ NORMAL ] )
			stat["Bio"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ BIO ] )
			stat["Cyber"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ CYBER ] )
			stat["Mental"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ MENTAL ] )
			stat["Kosmic"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ KOSMIC ] )
			stat["Zauber"] 		= int( JERKIN_LIST[ get_current_jerkin() ][ ZAUBER ] )
			stat["Description"] = JERKIN_LIST[ get_current_jerkin() ][ DESCRIPTION ]
	else:
		stat["Pkt"] 		= int( JERKIN_LIST[ jerkin ][ PKT ] )
		stat["Wgt"] 		= int( JERKIN_LIST[ jerkin ][ WGT ] )
		stat["Fsh"] 		= int( JERKIN_LIST[ jerkin ][ FSH ] )
		stat["Normal"] 		= int( JERKIN_LIST[ jerkin ][ NORMAL ] )
		stat["Bio"] 		= int( JERKIN_LIST[ jerkin ][ BIO ] )
		stat["Cyber"] 		= int( JERKIN_LIST[ jerkin ][ CYBER ] )
		stat["Mental"] 		= int( JERKIN_LIST[ jerkin ][ MENTAL ] )
		stat["Kosmic"] 		= int( JERKIN_LIST[ jerkin ][ KOSMIC ] )
		stat["Zauber"] 		= int( JERKIN_LIST[ jerkin ][ ZAUBER ] )
		stat["Description"] = JERKIN_LIST[ jerkin ][ DESCRIPTION ]
	return stat
	
static func equip_jerkin( jerkin : String ) -> void:
	if JERKIN_LIST.has(jerkin):
		if has_jerkin( jerkin ):
			B2_Config.set_user_save_data("player.jerkins.current", jerkin)
		else:
			push_error("Tried to equip a jerkin that was not owned.")
	else:
		push_error("Tried to equip an invalid jerkin.")
		
static func unequip_jerkin( jerkin : String ) -> void:
	if JERKIN_LIST.has(jerkin):
		if has_jerkin( jerkin ):
			B2_Config.set_user_save_data("player.jerkins.current", "")
		else:
			push_error("Tried to unequip a jerkin that was not owned.")
	else:
		push_error("Tried to unequip an invalid jerkin.")
		
static func gain_jerkin( jerkin : String ) -> void:
	if JERKIN_LIST.has(jerkin):
		if not has_jerkin( jerkin ):
			var my_jerkin : Array = list_jerkin()
			my_jerkin.append( jerkin )
			B2_Config.set_user_save_data( "player.jerkins.has", my_jerkin )
		else:
			push_error("Tried to remove a jerkin that was already owned.")
	else:
		push_error("Tried to gain an invalid jerkin.")
	
static func lose_jerkin( jerkin : String ) -> void:
	if JERKIN_LIST.has(jerkin):
		if has_jerkin( jerkin ):
			var my_jerkin : Array = list_jerkin()
			my_jerkin.erase( jerkin )
			B2_Config.set_user_save_data( "player.jerkins.has", my_jerkin )
		else:
			push_error("Tried to remove a jerkin that wasnt owned.")
	else:
		push_error("Tried to remove an invalid jerkin.")
