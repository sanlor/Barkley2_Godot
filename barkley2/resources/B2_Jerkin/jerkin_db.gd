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
	return B2_Config.get_user_save_data("player.jerkins.current", "")
	
static func list_jerkin() -> Array:
	return B2_Config.get_user_save_data("player.jerkins.has", [])
	
static func has_jerkin( jerkin : String ) -> bool:
	return B2_Config.get_user_save_data("player.jerkins.has", []).has(jerkin)
	
static func add_pocket_content( slot : int, item_name : String ) -> void:
	if get_jerkin_stats()[ "Pkt" ] > slot:
		if B2_Config.get_user_save_data("player.items.has", []).size() > slot:
			var items : Array = B2_Config.get_user_save_data( "player.items.has", [] )
			var empty_slot := items.find( null )
			if empty_slot == -1:
				items.append( item_name )
			else:
				items[empty_slot] = item_name
			B2_Config.set_user_save_data( "player.items.has", items )
		else:
			push_warning("Tried to add item when you have too many items. ", B2_Config.get_user_save_data("player.items.has", []).size(), " - ", slot)
	else:
		push_warning("Tried to add item when you have no avaiable pocket. ", get_jerkin_stats()[ "Pkt" ], " - ", slot)
	
static func remove_pocket_content( slot : int ) -> void:
	if get_jerkin_stats()[ "Pkt" ] > slot:
		if B2_Config.get_user_save_data("player.items.has", []).size() > slot:
			var items : Array = B2_Config.get_user_save_data( "player.items.has", [] )
			items.remove_at( slot )
			B2_Config.set_user_save_data( "player.items.has", items )
	
static func has_pocket_content( slot : int ) -> bool:
	if get_jerkin_stats()[ "Pkt" ] > slot:
		if B2_Config.get_user_save_data("player.items.has", []).size() > slot:
			if B2_Config.get_user_save_data("player.items.has", [])[ slot ]:
				return true
	return false
	
static func use_pocket_content( slot : int ) -> void:
	if get_jerkin_stats()[ "Pkt" ] > slot:
		if B2_Config.get_user_save_data("player.items.has", []).size() > slot:
			var item = get_pocket_content( slot )
			B2_Candy.use_candy( item )
			remove_pocket_content( slot )
			
	
static func get_pocket_content( slot : int ) -> String:
	if get_jerkin_stats()[ "Pkt" ] > slot:
		if B2_Config.get_user_save_data("player.items.has", []).size() > slot:
			return B2_Config.get_user_save_data("player.items.has", [] )[slot]
	
	## Invalid slot
	return ""

static func pockets() -> int: 
	return get_jerkin_stats()[ "Pkt" ]
	
static func pockets_free() -> int: # check scr_items_count, scr_items_getAll, Jerkin line 81
	return max( 0, get_jerkin_stats()[ "Pkt" ] - B2_Config.get_user_save_data("player.items.has", []).size() )
	
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
			push_warning("No jerkin equiped. Weird.")
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
