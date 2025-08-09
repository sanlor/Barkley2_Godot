extends Node
## TODO 08/08/25 save this data on a json file.
## TODO Implement icons
## TODO Remove this from an autoload

var sMapIconHoopz 		= null
var sMapIconCyberdwarf 	= null

var map_directory := {}

# Check Map()
# Script responsible to handle Maps, map locations and stupid shit like that.

func _init() -> void:
	init_setup()
	#gain_map( "The Eastelands" ) ## DEBUG
	#gain_map( "Sewers Floor 1" ) ## DEBUG

func init_setup() -> void:
	## add_icon("world map", 2, 211, 130, "area", "==", "swp"); ## In game example

	########################/    
	## World Map (Called "Necron 7 - 666th Floor")
	########################/
	add_area( "Necron 7 - 666th Floor", 0);
	## Districts ##
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 109, 89, "area", "==", "tnn");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 98, 113, "area", "==", "sw1");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 102, 121, "area", "==", "sw2");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 153, 90, "area", "==", "est");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 80, 91, "area", "==", "wst");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 274, 82, "area", "==", "pea");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 182, 57, "area", "==", "fct");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 270, 165, "area", "==", "min");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 193, 119, "area", "==", "far");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 136, 146, "area", "==", "swp");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 44, 123, "area", "==", "bct");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 75, 43, "area", "==", "ice");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 102, 185, "area", "==", "usw");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 213, 151, "area", "==", "aki");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 275, 39, "area", "==", "dth");
	add_icon("Necron 7 - 666th Floor", sMapIconHoopz, 240, 78, "area", "==", "pri");

	##The Hunt for Cyberdwarf
	add_icon("Necron 7 - 666th Floor", sMapIconCyberdwarf, 274, 24, "knowMagus", "==", "2");
	add_icon("Necron 7 - 666th Floor", sMapIconCyberdwarf, 274, 24, "knowMagus", "==", "3");

	########################/
	## Tír na nÓg 
	########################/
	add_area( "Tír na nÓg", 2);
	## Districts ##
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 197, 92, "room", "==", "r_tnn_residentialDistrict01", "x", "<", "588", "y", "<", "488");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 230, 152, "room", "==", "r_tnn_residentialDistrict01", "x", ">=", "588", "y", ">=", "488");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 231, 95, "room", "==", "r_tnn_residentialDistrict01", "x", ">=", "588", "y", "<", "488");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 191, 145, "room", "==", "r_tnn_residentialDistrict01", "x", "<", "588", "y", ">=", "488");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 49, 117, "room", "==", "r_tnn_warehouseDistrict01", "y", "<", "424");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 52, 147, "room", "==", "r_tnn_warehouseDistrict01", "y", ">=", "424");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 27, 70, "room", "==", "r_tnn_businessDistrict01", "x", "<", "856");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 73, 73, "room", "==", "r_tnn_businessDistrict01", "x", ">=", "856");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 145, 33, "room", "==", "r_tnn_marketDistrict01", "x", "<", "936", "y", "<", "560");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 187, 37, "room", "==", "r_tnn_marketDistrict01", "x", ">=", "936", "y", "<", "560");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 151, 70, "room", "==", "r_tnn_marketDistrict01", "x", "<", "936", "y", ">=", "560");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 214, 67, "room", "==", "r_tnn_marketDistrict01", "x", ">=", "936", "y", ">=", "560");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 117, 116, "room", "==", "r_tnn_maingate02", "y", "<", "130");
	# TODO # add_icon("Tír na nÓg", sMapIconHoopz, 125, 164, "room", "==", "r_tnn_maingate02", "y", ">=", "130");
	add_icon("Tír na nÓg", sMapIconHoopz, 283, 94, "room", "==", "r_tnn_bballcourt_transition01");
	add_icon("Tír na nÓg", sMapIconHoopz, 281, 62, "room", "==", "r_tnn_bballcourt02");

	## Interior Rooms ##
	add_icon("Tír na nÓg", sMapIconHoopz, 149, 41, "room", "==", "r_tnn_backshop01");
	add_icon("Tír na nÓg", sMapIconHoopz, 285, 43, "room", "==", "r_tnn_bballtenement01");
	add_icon("Tír na nÓg", sMapIconHoopz, 193, 118, "room", "==", "r_tnn_blockhouse01");
	add_icon("Tír na nÓg", sMapIconHoopz, 220, 145, "room", "==", "r_tnn_boardinghouse01");
	add_icon("Tír na nÓg", sMapIconHoopz, 65, 129, "room", "==", "r_tnn_bootybass02");
	add_icon("Tír na nÓg", sMapIconHoopz, 202, 35, "room", "==", "r_tnn_clinic01");
	add_icon("Tír na nÓg", sMapIconHoopz, 223, 168, "room", "==", "r_tnn_ghettoofsadness01");
	add_icon("Tír na nÓg", sMapIconHoopz, 248, 109, "room", "==", "r_tnn_ghosthouse01");
	add_icon("Tír na nÓg", sMapIconHoopz, 218, 48, "room", "==", "r_tnn_giuseppesChurch01");
	add_icon("Tír na nÓg", sMapIconHoopz, 71, 99, "room", "==", "r_tnn_gutterHouse01");
	add_icon("Tír na nÓg", sMapIconHoopz, 47, 72, "room", "==", "r_tnn_kelpstershouse01");
	add_icon("Tír na nÓg", sMapIconHoopz, 47, 99, "room", "==", "r_tnn_mortgage01");
	add_icon("Tír na nÓg", sMapIconHoopz, 208, 170, "room", "==", "r_tnn_petshop01");
	add_icon("Tír na nÓg", sMapIconHoopz, 43, 46, "room", "==", "r_tnn_rebelbase02");
	add_icon("Tír na nÓg", sMapIconHoopz, 249, 146, "room", "==", "r_tnn_rentcontrolled01");
	add_icon("Tír na nÓg", sMapIconHoopz, 32, 140, "room", "==", "r_tnn_warehouse01");
	add_icon("Tír na nÓg", sMapIconHoopz, 234, 125, "room", "==", "r_tnn_wilmer01");
	add_icon("Tír na nÓg", sMapIconHoopz, 234, 134, "room", "==", "r_tnn_wilmer02");
	add_icon("Tír na nÓg", sMapIconHoopz, 163, 27, "room", "==", "r_tnn_vivian02");
	## Kelpster ##
	# TODO # add_icon("Tír na nÓg", sMapIconGrapes,    47,  71,  "kelpsterState", "==", "2", "fruitbasketTake", "!=", "2");
	
	## Wilmer Quest ##
	# TODO # add_icon("Tír na nÓg", sMapIconRent, 46, 101, "wilmerEvict", "==", "1", "mortgageDoorRealize", "==", "0");
	
	##Demo Helper
	# TODO # add_icon("Tír na nÓg", sMapIconSewers, 204, 17, "knowLONGINUSTnn", ">=", "1");
	# TODO # add_icon("Tír na nÓg", sMapIconTutorial, 208, 93);
	
	##Lugner Quest
	# TODO # add_icon("Tír na nÓg", sMapIconHelper, 219, 49, "lugnerQuest", "==", "3");
	# TODO # add_icon("Tír na nÓg", sMapIconHelper, 19, 139, "lugnerQuest", ">=", "4", "lugnerQuest", "<=", "6", );
	
	##Main Quest
	# TODO # add_icon("Tír na nÓg", sMapIconExit, 123, 144, "operationX", "==", "2");

	############################/
	## Sewers Floor 1
	############################/
	add_area( "Sewers Floor 1", 1);
	##add_icon("Sewers Floor 1", sMapIconHoopz, 155, 58);##, "room", "==", "r_swr_room", "x", ">", "500");
	add_icon("Sewers Floor 1", sMapIconHoopz, 149, 32, "room", "==", "r_sw1_descent01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 154, 58, "room", "==", "r_sw1_fishersCreek01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 149, 88, "room", "==", "r_sw1_foyer01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 106, 86, "room", "==", "r_sw1_end01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 81, 98, "room", "==", "r_sw1_manholeWest01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 160, 119, "room", "==", "r_sw1_center01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 209, 119, "room", "==", "r_sw1_eastEdge01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 200, 142, "room", "==", "r_sw1_secret01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 243, 119, "room", "==", "r_sw1_treasureDwarf01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 210, 87, "room", "==", "r_sw1_crossroads01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 247, 98, "room", "==", "r_sw1_manholeEast01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 248, 79, "room", "==", "r_sw1_baldomero01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 248, 59, "room", "==", "r_sw1_closet01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 225, 58, "room", "==", "r_sw1_elemental01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 203, 58, "room", "==", "r_sw1_respawn01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 157, 150, "room", "==", "r_sw1_rathell01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 120, 182, "room", "==", "r_sw1_southEdge01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 53, 149, "room", "==", "r_sw1_gap01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 55, 103, "room", "==", "r_sw1_gutterGate01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 81, 126, "room", "==", "r_sw1_plantation02"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 117, 129, "room", "==", "r_sw1_pool01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 243, 162, "room", "==", "r_sw1_floor2Access01"); ## - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 265, 142, "room", "==", "r_sw1_utility01"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 265, 164, "room", "==", "r_sw1_joad01"); ##  - 
	# TODO # add_icon("Sewers Floor 1", sMapIconHoopz, 125, 160, "room", "==", "r_sw1_longWays01", "x", ">=", "648"); ##  - 
	# TODO # add_icon("Sewers Floor 1", sMapIconHoopz, 86, 159, "room", "==", "r_sw1_longWays01", "x", "<", "648"); ##  - 
	add_icon("Sewers Floor 1", sMapIconHoopz, 243, 143, "room", "==", "r_sw1_tnnShortcut01"); ##  - 
	##add_icon("Sewers Floor 1", sMapIconHoopz, , , "room", "==", "");

	############################/
	## Sewers Floor 2
	############################/
	add_area( "Sewers Floor 2", 3);
	##add_icon("Sewers Floor 1", sMapIconHoopz, 155, 58);##, "room", "==", "r_swr_room", "x", ">", "500");
	add_icon("Sewers Floor 2", sMapIconHoopz, 149, 155, "room", "==", "r_sw2_balcony01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 102, 151, "room", "==", "r_sw2_bridges01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 53, 133, "room", "==", "r_sw2_crossing01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 81, 91, "room", "==", "r_sw2_crossroad01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 289, 73, "room", "==", "r_sw2_eastExit01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 88, 64, "room", "==", "r_sw2_end01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 105, 119, "room", "==", "r_sw2_gordo01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 248, 117, "room", "==", "r_sw2_hermitPass01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 50, 63, "room", "==", "r_sw2_indianRopeTrick01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 134, 64, "room", "==", "r_sw2_looparound01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 181, 104, "room", "==", "r_sw2_pools01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 182, 153, "room", "==", "r_sw2_respawn01"); 
	add_icon("Sewers Floor 2", sMapIconHoopz, 152, 89, "room", "==", "r_sw2_safeRoom01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 201, 67, "room", "==", "r_sw2_sludgeFloor01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 152, 115, "room", "==", "r_sw2_start01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 186, 143, "room", "==", "r_sw2_steam01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 250, 74, "room", "==", "r_sw2_steam02");
	add_icon("Sewers Floor 2", sMapIconHoopz, 216, 99, "room", "==", "r_sw2_treasureDwarf01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 261, 35, "room", "==", "r_sw2_undersewerAccess01");
	add_icon("Sewers Floor 2", sMapIconHoopz, 74, 166, "room", "==", "r_sw2_utility01"); 
	##add_icon("Sewers Floor 1", sMapIconHoopz, , , "room", "==", ""); 

	############################/
	## The Eastelands
	############################/
	add_area( "The Eastelands", 4);
	##add_icon("Sewers Floor 1", sMapIconHoopz, 155, 58);##, "room", "==", "r_swr_room", "x", ">", "500");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 161, 121, "room", "==", "r_est_cgremArena01", "x", "<=", "415");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 208, 121, "room", "==", "r_est_cgremArena01", "x", ">=", "416");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 155, 169, "room", "==", "r_est_cgremPath01", "y", ">=", "560");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 152, 143, "room", "==", "r_est_cgremPath01", "y", "<=", "559");
	add_icon("The Eastelands", sMapIconHoopz, 156, 82, "room", "==", "r_est_cgremVillage01");
	add_icon("The Eastelands", sMapIconHoopz, 101, 158, "room", "==", "r_est_difficultyFork01");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 193, 80, "room", "==", "r_est_easternPaths01", "y", "<=", "423");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 193, 80, "room", "==", "r_est_easternPaths01", "y", ">=", "424", "x", "<=", "367");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 208, 92, "room", "==", "r_est_easternPaths01", "y", ">=", "424", "x", ">=", "368");
	add_icon("The Eastelands", sMapIconHoopz, 178, 53, "room", "==", "r_est_industrialPlaza01");
	add_icon("The Eastelands", sMapIconHoopz, 250, 55, "room", "==", "r_est_industrialRock01");
	add_icon("The Eastelands", sMapIconHoopz, 170, 28, "room", "==", "r_est_industrialZone01");
	add_icon("The Eastelands", sMapIconHoopz, 250, 80, "room", "==", "r_est_junkworms01");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 298, 39, "room", "==", "r_est_mountainBase01", "y", "<=", "1208");
	# TODO # add_icon("The Eastelands", sMapIconHoopz, 298, 70, "room", "==", "r_est_mountainBase01", "y", ">=", "1208");
	add_icon("The Eastelands", sMapIconHoopz, 313, 49, "room", "==", "r_est_mountainPath01");
	add_icon("The Eastelands", sMapIconHoopz, 225, 96, "room", "==", "r_est_pythagoras01");
	add_icon("The Eastelands", sMapIconHoopz, 165, 190, "room", "==", "r_est_southDeadend01");
	add_icon("The Eastelands", sMapIconHoopz, 67, 185, "room", "==", "r_est_southScam01");
	add_icon("The Eastelands", sMapIconHoopz, 249, 167, "room", "==", "r_est_southBeach01");
	add_icon("The Eastelands", sMapIconHoopz, 202, 155, "room", "==", "r_est_swampZigzag01"); 
	##add_icon("The Eastelands", sMapIconHoopz, 32, 150, "room", "==", "r_est_tnnEntrance01", "y", "<=", "604");
	##add_icon("The Eastelands", sMapIconHoopz, 40, 170, "room", "==", "r_est_tnnEntrance01", "y", ">=", "605" );
	add_icon("The Eastelands", sMapIconHoopz, 99, 190, "room", "==", "r_est_tnnRespawn01");
	add_icon("The Eastelands", sMapIconHoopz, 130, 41, "room", "==", "r_est_turretGauntlet01");
	##add_icon("Sewers Floor 1", sMapIconHoopz, , , "room", "==", ""); 

	############################/
	## The Path to the Foopba through Hoosegow, written on Burger Wrapper
	############################/
	add_area( "Gilbert's Base", 5);
	##TODO: add the areas to this map

	############################/
	## Gilbert's Grave Sites Map, Top of Gilbert's Peak from Compson
	############################/
	add_area( "Gilbert Grave Sites", 6);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Mines Map
	############################/
	add_area( "Mines Map", 7);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Westelands Map
	############################/
	add_area( "Westelands Map", 8);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Factory Map - Floor One
	############################/
	add_area( "Factory Map, Floor 1", 9);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Factory Map - Floor Two
	############################/
	add_area( "Factory Map, Floor 2", 10);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Icelands Map
	############################/
	add_area( "Icelands Map", 11);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Swamp Map 1
	############################/
	add_area( "Swamp Map 1", 12);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Icelands Map
	############################/
	add_area( "Swamp Map 2", 13);
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Brain City Map - Purchased at Info Kiosk in BCT
	############################/
	add_area( "Brain City Directory", 14)
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Path to the Rootstock - Given to you by Jhodfrey
	############################/
	add_area( "Path to the Rootstock", 15)
	##TODO: add areas to this map once we have the final sprite

	############################/
	## Route to Ai Ruins
	############################/
	add_area( "Route to the AI Ruins", 16)
	##TODO: add areas to this map once we have the final sprite
		
	############################/
	## Template
	############################/
	##add_icon("The Westelands", sMapIconHoopz, 32, 150, "room", "==", "r_wst_tnnEntrance01", "y", "<=", "604");
	##add_icon("The Westelands", sMapIconHoopz, 40, 170, "room", "==", "r_wst_tnnEntrance01", "y", ">=", "605" );


## NOTE This should only be used during startup.
## Map("add area", <map name>, <sMap subimage>)
@warning_ignore("unused_variable")
@warning_ignore("unused_parameter")
func add_area( map_name : String, map_sub : int ) -> void:
	map_directory[map_sub] = map_name

## NOTE This should only be used during startup.
## add icon("world map", 0,   100, 100, "knowCdwarf", ">=",    "1")
## TODO What a mess. this methd supports multiple conditions.
# Im just going to ignore most of it.
@warning_ignore("unused_variable")
@warning_ignore("unused_parameter")
func add_icon( area_name, map_sub, x, y, variable, compare, value) -> void:
	pass


# Return all the maps that the player have.
func get_all() -> Array:
	# an array with the names of all the players maps.
	var my_maps = B2_Config.get_user_save_data("quest.maps", [] )
	
	# Aditional check. during initial load, this value is an dictionary for some reason. This part of the code should "convert" it to an array.
	if my_maps is not Array:
		my_maps = []
	
	if my_maps.is_empty():
		return []
		
	else:
		var id_array := [] # an array with all ids.
		for i in my_maps:
			id_array.append( map_directory.find_key(i) )
		return id_array
		
## Map("reset") - Call every time the game resets.
## NOTE maybe unused in this version?
func reset_maps() -> void:
	B2_Config.set_user_save_data("quest.maps", Array() )
	
func gain_map( map_name : String ) -> bool:
	# Check if the map name is valid
	if map_directory.values().has( map_name ):
		# get current maps
		var my_maps = B2_Config.get_user_save_data("quest.maps", [] )
		
		# Aditional check. during initial load, this value is an dictionary for some reason. This part of the code should "convert" it to an array.
		if my_maps is not Array:
			my_maps = []
			
		# if you already have the map, do not add it again
		if not my_maps.has( map_name ):
			my_maps.append( map_name )
			# save the map to mmeory
			B2_Config.set_user_save_data( "quest.maps", my_maps )
		return true
	else:
		# map name is invalid, throw an error message.
		push_error( "Cannot gain map %s that isn't defined." % map_name )
		return false
