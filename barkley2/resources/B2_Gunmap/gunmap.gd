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
static var GUNMAP_DEFINE := {
	B2_Gun.TYPE.GUN_TYPE_NONE:				[B2_Gun.GROUP.NONE,     00, 	Color.BLACK],
	
	B2_Gun.TYPE.GUN_TYPE_PISTOL:         	[B2_Gun.GROUP.PISTOLS,  40, 	Color.from_hsv(0.00, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:      	[B2_Gun.GROUP.PISTOLS,  20, 	Color.from_hsv(0.03, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_REVOLVER:       	[B2_Gun.GROUP.PISTOLS,  28, 	Color.from_hsv(0.07, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_MAGNUM:         	[B2_Gun.GROUP.PISTOLS,  08, 	Color.from_hsv(0.11, 1.0, 1.0)],
	
	B2_Gun.TYPE.GUN_TYPE_RIFLE:          	[B2_Gun.GROUP.RIFLES,   30, 	Color.from_hsv(0.15, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_MUSKET:         	[B2_Gun.GROUP.RIFLES,   20, 	Color.from_hsv(0.19, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE:   	[B2_Gun.GROUP.RIFLES,   18, 	Color.from_hsv(0.23, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE:    	[B2_Gun.GROUP.RIFLES,   06, 	Color.from_hsv(0.27, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE:     	[B2_Gun.GROUP.RIFLES,   10, 	Color.from_hsv(0.31, 0.5, 0.5)],
	
	B2_Gun.TYPE.GUN_TYPE_SHOTGUN:        	[B2_Gun.GROUP.SHOTGUNS, 25, 	Color.from_hsv(0.35, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN:    	[B2_Gun.GROUP.SHOTGUNS, 15, 	Color.from_hsv(0.39, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN:  	[B2_Gun.GROUP.SHOTGUNS, 15, 	Color.from_hsv(0.43, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:	[B2_Gun.GROUP.SHOTGUNS, 05, 	Color.from_hsv(0.47, 1.0, 1.0)],
	
	B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN:  	[B2_Gun.GROUP.AUTOMATIC,18, 	Color.from_hsv(0.50, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE:   	[B2_Gun.GROUP.AUTOMATIC,18, 	Color.from_hsv(0.54, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:	[B2_Gun.GROUP.AUTOMATIC,12, 	Color.from_hsv(0.58, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL:  	[B2_Gun.GROUP.AUTOMATIC,12, 	Color.from_hsv(0.62, 0.5, 0.5)],
	
	B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:     	[B2_Gun.GROUP.MOUNTED,  12, 	Color.from_hsv(0.66, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:   	[B2_Gun.GROUP.MOUNTED,  07, 	Color.from_hsv(0.70, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_MINIGUN:        	[B2_Gun.GROUP.MOUNTED,  03, 	Color.from_hsv(0.74, 1.0, 1.0)],
	B2_Gun.TYPE.GUN_TYPE_BFG:            	[B2_Gun.GROUP.MOUNTED,  01, 	Color.from_hsv(0.78, 1.0, 1.0)],
	
	B2_Gun.TYPE.GUN_TYPE_CROSSBOW:       	[B2_Gun.GROUP.PROJECTILE, 18, 	Color.from_hsv(0.82, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_FLAREGUN:       	[B2_Gun.GROUP.PROJECTILE, 10, 	Color.from_hsv(0.86, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_ROCKET:         	[B2_Gun.GROUP.PROJECTILE, 04, 	Color.from_hsv(0.90, 0.5, 0.5)],
	B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:   	[B2_Gun.GROUP.PROJECTILE, 03, 	Color.from_hsv(0.94, 0.5, 0.5)],
}
const DIRECTIONS : Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
	Vector2i.UP + Vector2i.LEFT,
	Vector2i.UP + Vector2i.RIGHT,
	Vector2i.DOWN + Vector2i.LEFT,
	Vector2i.DOWN + Vector2i.RIGHT,
]


const RAYCAST_TTL		:= 16	## How far can a raycast go
#const RAYCAST_SPREAD	:= 16	## Amount of raycasts to cast on each permutation
static var PERMUTATIONS 		:= 16
const GROUP_SIZE		:= 30
const TYPE_SPREAD		:= 20

static func get_gun_map( size := Vector2i(80,80) ) -> Texture:
	@warning_ignore("narrowing_conversion")
	var img := Image.create_empty(size.x, size.y, false, Image.FORMAT_RGB8)
	img.fill( Color.BLACK )
	# I dont give a fuck anymore. Porting this mess of a code not knowing how it should work is not fun
	#var fuckfuckfuck := [] 		## Array of noise stuff
	var gun_type_map			: Dictionary[Vector2i,B2_Gun.TYPE] 	= {}		## Dictionary with data related to gunmap.
	var gun_type_claimed_pos	: Dictionary[B2_Gun.TYPE,Array] 	= {}		## Dictionary with "personal" positions occupied by each type.
	var gun_group_claimed_pos	: Dictionary[B2_Gun.GROUP,Vector2i] = {}		## Dictionary with group positions.
	
	## make an empty dictionary with blank data
	for x : int in size.x:
		for y : int in size.y:
			gun_type_map[ Vector2i(x,y) ] = B2_Gun.TYPE.GUN_TYPE_NONE
	
	var fuckme := RandomNumberGenerator.new()
	#fuckme.seed = hash("AAAAAAAAAAAAA I HATE THIS") ## Make this "random" function predictive
	var my_seed : int = B2_Config.get_user_save_data( "gunsmap.seed", 69 + 420 )
	if my_seed == 69 + 420:
		push_warning("Gunmap seed not set. throwing a random seed.")
		my_seed = randi()
	my_seed = 111111 ## DEBUG
	fuckme.seed = my_seed
	# lol, forgot about how frustated I was when writing this.
	
	# set regions for gun groups, so that similar guns are spawn together.
	for i : B2_Gun.GROUP in B2_Gun.GROUP.values():
		var group_region_pos := Vector2i( fuckme.randi_range(-GROUP_SIZE,GROUP_SIZE), fuckme.randi_range(-GROUP_SIZE,GROUP_SIZE) )
		gun_group_claimed_pos[i] = Vector2i(group_region_pos + size / 2).clamp( Vector2.ZERO, size - Vector2i.ONE )
	
	## create seed points
	for i : B2_Gun.TYPE in B2_Gun.TYPE.values(): # 27 types of guns - Add seed position.
		var region_pos := gun_group_claimed_pos[ GUNMAP_DEFINE[i][GROUP] ]
		var gunman_pos := Vector2i( region_pos + Vector2i( fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD), fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD) ) ).clamp( Vector2.ZERO, size - Vector2i.ONE )
		while gun_type_map[gunman_pos] != B2_Gun.TYPE.GUN_TYPE_NONE: # Reroll position while you have a duplicated position in the map.
			gunman_pos = region_pos + Vector2i( fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD), fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD) )
		
		gun_type_map[gunman_pos] = i							## Claimed position on the "global" map.
		gun_type_claimed_pos[i] = [gunman_pos]					## Claimed position stored on the "personal" map.
	
	## expand the initial seed points
	for i : B2_Gun.TYPE in B2_Gun.TYPE.values(): # 27 types of guns - Add seed position.
		var gunman_pos = gun_type_claimed_pos[i].front()
		for d : Vector2i in DIRECTIONS:
			var new_gunman_pos := Vector2i(gunman_pos + d).clamp(Vector2i.ZERO, size - Vector2i.ONE)
			if not gun_type_map[new_gunman_pos] != B2_Gun.TYPE.GUN_TYPE_NONE: # avoid overiding other gun types
				gun_type_map[new_gunman_pos] = i							## Claimed position on the "global" map + offset.
				gun_type_claimed_pos[i].append(new_gunman_pos)					## Claimed position stored on the "personal" map + offset.
		
	## Fill the map
	for i : int in PERMUTATIONS:
		for gun_type : B2_Gun.TYPE in B2_Gun.TYPE.values(): # Do each permutation in parallel for each gun type
			for ii : int in GUNMAP_DEFINE[gun_type][RARITY]: # Apply spread along with rarity
				var set_init_pos := func() -> Vector2i:
					return gun_type_claimed_pos[gun_type][ fuckme.randi_range(0, gun_type_claimed_pos[gun_type].size() - 1) ]
				var set_rand_dir := func() -> Vector2i:
					var dir := Vector2i.ZERO
					while dir == Vector2i.ZERO:
						dir = Vector2i( fuckme.randi_range(-1,1), fuckme.randi_range(-1,1) )
					return dir
					
				var initial_pos 	: Vector2i = set_init_pos.call() # intial position is picked at random
				var ray_direction 	: Vector2i = set_rand_dir.call() # direction is picket at random
				var curr_pos		:= initial_pos + ray_direction
				
				## Tries to reach an unnocupied space.
				for step in RAYCAST_TTL:
					if curr_pos.x in range(0,size.x) and curr_pos.y in range(0,size.y): # Check if position is in bounds.
						if gun_type_map[curr_pos] == B2_Gun.TYPE.GUN_TYPE_NONE:	# Spot is vacant
							gun_type_map[curr_pos] = gun_type							## Claimed position on the "global" map.
							gun_type_claimed_pos[gun_type].append(curr_pos)				## Claimed position stored on the "personal" map.
							break
						elif gun_type_map[curr_pos] == gun_type: # spot already is occupied with my own type. carry on.
							curr_pos += ray_direction
							continue
						else: # spot already is occupied with my a different type. stop trying.
							initial_pos 	= set_init_pos.call() # intial position is picked at random
							ray_direction 	= set_rand_dir.call() # direction is picket at random
							curr_pos		= initial_pos + ray_direction
							continue
					else: ## position is out of bounds, stop raycasting
						initial_pos 	= set_init_pos.call() # intial position is picked at random
						ray_direction 	= set_rand_dir.call() # direction is picket at random
						curr_pos		= initial_pos + ray_direction
						continue
		
	# Draw the fucking map.
	for map_pos : Vector2i in gun_type_map:
			var gun_type : B2_Gun.TYPE = gun_type_map[ map_pos ]
			var c : Color = GUNMAP_DEFINE[gun_type][COLOR]
			img.set_pixel( map_pos.x, map_pos.y, c )
			#if gun_type != 25: print(gun_type,map_pos)
	return ImageTexture.create_from_image( img )
	
static func get_gun_map_position( dont_care := 2, wpn_name := "", size := Vector2(80,80) ) -> Vector2:
	var fuckyou := RandomNumberGenerator.new()
	fuckyou.seed = hash("IS THIS HAPPENING FOR REAL?????") + hash(dont_care) + hash(wpn_name) ## Make this "random" function predictive
	@warning_ignore("narrowing_conversion")
	return Vector2( fuckyou.randi_range(0, size.x), fuckyou.randi_range(0, size.y) )
