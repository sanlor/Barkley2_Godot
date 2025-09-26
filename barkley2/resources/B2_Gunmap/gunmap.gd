extends RefCounted
class_name B2_Gunmap
## Check Gunsmap("draw")
# This is very stupid. This draws a little map related to the gun lineage. As of 14/06/25, lineage does not work. Even now I have no idea how this map is generated.
# What the fuck. check line 417. what kind of drugs where these guys on? 

## NOTE Motherfucker, this function uses a file called "gunsmap.ini". That does this function even does??????? is this important?

# 26/09/25 now its time to work on this. Here is what I found so far:
# Gunsmap is actually important, its how gun types are defined during fusing.
# Each color on the map is a gun type. a fused gun takes the average (with or without bias) of both map positions to set the new type.
# NOTE The old code is too confusing. love the 3 letter variables and the lack of comments!
# yeah, maybe making my own implementations is a better idea.
## https://www.gamegeniuslab.com/tutorial-post/voronoi-diagrams-in-game-development-procedural-maps-ai-territories-stylish-effects/
## https://christianjmills.com/posts/procedural-map-generation-techniques-notes/
##		Diffusion-Limited Aggregation (DLA) seems cool.
# CRITICAL -> https://youtu.be/_G7RFRYjUtM

enum {TOP, BOTTOM, OCCUPIED}


enum{										GROUP,					RARITY,	COLOR}
const GUNMAP_DEFINE := {
	B2_Gun.TYPE.GUN_TYPE_NONE:				[B2_Gun.GROUP.NONE,     00, 	Color.BLACK],
	
	B2_Gun.TYPE.GUN_TYPE_PISTOL:         	[B2_Gun.GROUP.PISTOLS,  40, 	Color8(000, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:      	[B2_Gun.GROUP.PISTOLS,  20, 	Color8(010, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_REVOLVER:       	[B2_Gun.GROUP.PISTOLS,  28, 	Color8(020, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_MAGNUM:         	[B2_Gun.GROUP.PISTOLS,  08, 	Color8(030, 255, 255)],
	
	B2_Gun.TYPE.GUN_TYPE_RIFLE:          	[B2_Gun.GROUP.RIFLES,   30, 	Color8(040, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_MUSKET:         	[B2_Gun.GROUP.RIFLES,   20, 	Color8(050, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE:   	[B2_Gun.GROUP.RIFLES,   18, 	Color8(060, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE:    	[B2_Gun.GROUP.RIFLES,   06, 	Color8(070, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE:     	[B2_Gun.GROUP.RIFLES,   10, 	Color8(080, 128, 128)],
	
	B2_Gun.TYPE.GUN_TYPE_SHOTGUN:        	[B2_Gun.GROUP.SHOTGUNS, 25, 	Color8(090, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN:    	[B2_Gun.GROUP.SHOTGUNS, 15, 	Color8(100, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN:  	[B2_Gun.GROUP.SHOTGUNS, 15, 	Color8(110, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:	[B2_Gun.GROUP.SHOTGUNS, 05, 	Color8(120, 255, 255)],
	
	B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN:  	[B2_Gun.GROUP.AUTOMATIC,18, 	Color8(130, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE:   	[B2_Gun.GROUP.AUTOMATIC,18, 	Color8(140, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:	[B2_Gun.GROUP.AUTOMATIC,12, 	Color8(150, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL:  	[B2_Gun.GROUP.AUTOMATIC,12, 	Color8(160, 128, 128)],
	
	B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:     	[B2_Gun.GROUP.MOUNTED,  12, 	Color8(170, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:   	[B2_Gun.GROUP.MOUNTED,  07, 	Color8(180, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_MINIGUN:        	[B2_Gun.GROUP.MOUNTED,  03, 	Color8(190, 255, 255)],
	B2_Gun.TYPE.GUN_TYPE_BFG:            	[B2_Gun.GROUP.MOUNTED,  01, 	Color8(200, 255, 255)],
	
	B2_Gun.TYPE.GUN_TYPE_CROSSBOW:       	[B2_Gun.GROUP.PROJECTILE, 18, 	Color8(210, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_FLAREGUN:       	[B2_Gun.GROUP.PROJECTILE, 10, 	Color8(220, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_ROCKET:         	[B2_Gun.GROUP.PROJECTILE, 04, 	Color8(230, 128, 128)],
	B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:   	[B2_Gun.GROUP.PROJECTILE, 03, 	Color8(240, 128, 128)],
}

const PERMUTATIONS := 16

static func get_gun_map( size := Vector2(80,80) ) -> Texture:
	@warning_ignore("narrowing_conversion")
	var img := Image.create_empty(size.x, size.y, false, Image.FORMAT_RGB8)
	img.fill( Color.BLACK )
	# I dont give a fuck anymore. Porting this mess of a code not knowing how it should work is not fun
	#var fuckfuckfuck := [] 		## Array of noise stuff
	var gun_type_map			: Dictionary[Vector2i,B2_Gun.TYPE] = {}		## Dictionary with data related to gunmap.
	var gun_type_claimed_pos	: Dictionary[B2_Gun.TYPE,Array] = {}		## Dictionary with "personal" positions occupied by each type.
	
	## make an empty dictionary with blank data
	for x : int in size.x - 1:
		for y : int in size.y - 1:
			gun_type_map[ Vector2i(x,y) ] = B2_Gun.TYPE.GUN_TYPE_NONE
	
	var fuckme := RandomNumberGenerator.new()
	#fuckme.seed = hash("AAAAAAAAAAAAA I HATE THIS") ## Make this "random" function predictive
	var my_seed : int = B2_Config.get_user_save_data( "gunsmap.seed", 69 + 420 )
	if my_seed == 69 + 420:
		push_warning("Gunmap seed not set. throwing a random seed.")
		my_seed = randi()
	fuckme.seed = my_seed
	# lol, forgot about how frustated I was when writing this.
	
	for i in B2_Gun.TYPE.values(): # 27 types of guns - Add seed position.
		var gunman_pos := Vector2i( fuckme.randi_range(0,79), fuckme.randi_range(0,79) )
		while not gun_type_map.has(gunman_pos): # Reroll position while you have a duplicated position in the map.
			gunman_pos = Vector2i( fuckme.randi_range(0,79), fuckme.randi_range(0,79) )
		
		gun_type_map[ gunman_pos ] = i							## Claimed position on the "global" map.
		gun_type_claimed_pos[i] = [ gun_type_claimed_pos ]		## Claimed position stored on the "personal" map.
		
	## Fill the map
	for i : int in PERMUTATIONS:
		pass
		
	# Draw the fucking map.
	for map_pos : Vector2i in gun_type_map:
			var gun_type : B2_Gun.TYPE = gun_type_map[ map_pos ]
			var c : Color = GUNMAP_DEFINE[gun_type][COLOR]
			img.set_pixel( map_pos.x, map_pos.y, c )
			if gun_type != 25: print(gun_type,map_pos)
	return ImageTexture.create_from_image( img )
	
static func get_gun_map_position( dont_care := 2, wpn_name := "", size := Vector2(80,80) ) -> Vector2:
	var fuckyou := RandomNumberGenerator.new()
	fuckyou.seed = hash("IS THIS HAPPENING FOR REAL?????") + hash(dont_care) + hash(wpn_name) ## Make this "random" function predictive
	@warning_ignore("narrowing_conversion")
	return Vector2( fuckyou.randi_range(0, size.x), fuckyou.randi_range(0, size.y) )
