## Resource used to get actor portraits and stuff.
# If new portraits were added, you can reindex it (as long as its inside the editor).
# Stuff that were on B2_Gamedata was split into B2_Portrait and B2_Color

extends RefCounted
class_name B2_Portrait

const PORTRAIT_PATH 			:= "res://barkley2/assets/b2_original/portraits/"								## Portrait image path.
const PORTRAIT_INDEX 			:= preload("res://barkley2/resources/B2_Portrait/portrait_index.json")			## Index for each image file, using the name as a index.
const PORTRAIT_NAME_INDEX 		:= preload("res://barkley2/resources/B2_Portrait/portrait_name_index.json")		## Index for the portrati name, using the actor name as a index.

const FORCE_REINDEX 			:= false

# check Portrait("init")
## Man, what a mess. its 30-12-24 and im still having issues with this.
# charcters portraits have some weird pattern on them. some have the _strip suffix and others not.
# why? who knows.
static func _load_portrait_data():
	var portrait_map := {}
	var time := Time.get_ticks_msec()
	for file : String in DirAccess.get_files_at( PORTRAIT_PATH ):
		if file.begins_with("s_port_"):
			if file.ends_with(".png.import"): ## Godot stuff.
				## NOTE 16/08/25 vvvvvv Why is this here?
				# Seems to be an issue with the portrait formating. -> s_port_tutorialbot_strip4.png.import
				# No idea how the game handles it, but we need to strip the "_strip4" off the file.
				# the issue is with some exceptions, like "s_port_mortimer_rob.png.import", so I cant rely on the "_" count. FUCK.
				if file.contains("strip"):
					if file.count("_") > 2: 
						portrait_map[ file.rsplit("_", false, 1)[ 0 ] ] = file.trim_suffix(".import")
					#print(file)
				else:
					portrait_map[ file.trim_suffix(".import").trim_suffix(".png") ] = file.trim_suffix(".import")
	
	var file = FileAccess.open( "res://barkley2/resources/B2_Portrait/portrait_index.json", FileAccess.WRITE )
	file.store_string( JSON.stringify(portrait_map, "\t") )
	
	print("_load_portrait_data() - Added " + str( portrait_map.size() ) + " portraits in %s msecs." % str( Time.get_ticks_msec() - time ) )

## Get portrait name based on the actor name. Ex.: "Baldomero": "s_port_baldomero",
static func get_actor_portrait( actor_name : String ) -> String:
	return B2_Portrait.PORTRAIT_NAME_INDEX.data.get( actor_name, "s_portrait" )

## Get portrait file path based on the portrait name. Ex.: "s_port_burglecut": "s_port_burglecut_strip6.png",
static func get_portrait_file_path( portrait_name : String ) -> String:
	return B2_Portrait.PORTRAIT_INDEX.data.get( portrait_name, "" )

# get currents hoopz portrait.
# Hoopz portrait can change when bodyswapping (Diaper > Normal)
## FIXME 17/08/25 This function is old. move it to B2_CManager
static func get_hoopz_portrait() -> String:
	match B2_Config.get_user_save_data("player.body"):
		"hoopz":			return "s_port_hoopz"
		"governor":			return "s_port_governor"
		"matthias":			return "s_port_matthias"
		"untamo":			return "s_port_untamo"
		"diaper":			return "s_port_hoopzDiaper"
		"prison":			return "s_port_hoopzPrison"
		_:
			# Invalid hoopz state
			#breakpoint
			push_warning( "Invalid hoopz state %s." % str( B2_Config.get_user_save_data("player.body") ) )
			return "s_port_hoopz"
