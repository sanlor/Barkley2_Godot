extends RefCounted
class_name B2_Gunmap

const DEBUG := true

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
	B2_Gun.TYPE.GUN_TYPE_NONE:				[B2_Gun.GROUP.NONE,     00, 	[0.00, 0.0, 0.0]],
	
	B2_Gun.TYPE.GUN_TYPE_PISTOL:         	[B2_Gun.GROUP.PISTOLS,  40, 	[0.00, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:      	[B2_Gun.GROUP.PISTOLS,  20, 	[0.03, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_REVOLVER:       	[B2_Gun.GROUP.PISTOLS,  28, 	[0.07, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_MAGNUM:         	[B2_Gun.GROUP.PISTOLS,  08, 	[0.11, 1.0, 1.0]],
	
	B2_Gun.TYPE.GUN_TYPE_RIFLE:          	[B2_Gun.GROUP.RIFLES,   30, 	[0.15, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_MUSKET:         	[B2_Gun.GROUP.RIFLES,   20, 	[0.19, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE:   	[B2_Gun.GROUP.RIFLES,   18, 	[0.23, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE:    	[B2_Gun.GROUP.RIFLES,   06, 	[0.27, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE:     	[B2_Gun.GROUP.RIFLES,   10, 	[0.31, 0.5, 0.5]],
	
	B2_Gun.TYPE.GUN_TYPE_SHOTGUN:        	[B2_Gun.GROUP.SHOTGUNS, 25, 	[0.35, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN:    	[B2_Gun.GROUP.SHOTGUNS, 15, 	[0.39, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN:  	[B2_Gun.GROUP.SHOTGUNS, 15, 	[0.43, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:	[B2_Gun.GROUP.SHOTGUNS, 05, 	[0.47, 1.0, 1.0]],
	
	B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN:  	[B2_Gun.GROUP.AUTOMATIC,18, 	[0.50, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE:   	[B2_Gun.GROUP.AUTOMATIC,18, 	[0.54, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:	[B2_Gun.GROUP.AUTOMATIC,12, 	[0.58, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL:  	[B2_Gun.GROUP.AUTOMATIC,12, 	[0.62, 0.5, 0.5]],
	
	B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:     	[B2_Gun.GROUP.MOUNTED,  12, 	[0.66, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:   	[B2_Gun.GROUP.MOUNTED,  07, 	[0.70, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_MINIGUN:        	[B2_Gun.GROUP.MOUNTED,  03, 	[0.74, 1.0, 1.0]],
	B2_Gun.TYPE.GUN_TYPE_BFG:            	[B2_Gun.GROUP.MOUNTED,  01, 	[0.78, 1.0, 1.0]],
	
	B2_Gun.TYPE.GUN_TYPE_CROSSBOW:       	[B2_Gun.GROUP.PROJECTILE, 18, 	[0.82, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_FLAREGUN:       	[B2_Gun.GROUP.PROJECTILE, 10, 	[0.86, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_ROCKET:         	[B2_Gun.GROUP.PROJECTILE, 04, 	[0.90, 0.5, 0.5]],
	B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:   	[B2_Gun.GROUP.PROJECTILE, 03, 	[0.94, 0.5, 0.5]],
}
const DIRECTIONS : Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
	Vector2i.UP 	+ Vector2i.LEFT,
	Vector2i.UP 	+ Vector2i.RIGHT,
	Vector2i.DOWN 	+ Vector2i.LEFT,
	Vector2i.DOWN 	+ Vector2i.RIGHT,
	Vector2i.UP 	+ Vector2i.UP,
	Vector2i.DOWN 	+ Vector2i.DOWN,
	Vector2i.LEFT 	+ Vector2i.LEFT,
	Vector2i.RIGHT 	+ Vector2i.RIGHT,
]

const SIZE				:= Vector2i(80,80)
const RAYCAST_TTL		:= 8	## How far can a raycast go
#const RAYCAST_SPREAD	:= 16	## Amount of raycasts to cast on each permutation
static var PERMUTATIONS := 16
const GROUP_SIZE		:= 30
const TYPE_SPREAD		:= 20

static var gun_type_map				: Dictionary[Vector2i,B2_Gun.TYPE] 	= {}		## Dictionary with data related to gunmap.
static var gun_type_claimed_pos		: Dictionary[B2_Gun.TYPE,Array] 	= {}		## Dictionary with "personal" positions occupied by each type.
static var gun_group_claimed_pos	: Dictionary[B2_Gun.GROUP,Vector2i] = {}		## Dictionary with group positions.
static var fuckme 					: RandomNumberGenerator

static func generate_map() -> void:
	## Set some bullshit.
	var start_time := Time.get_ticks_msec() ## keep track of time for debug purposes.
	gun_type_map.clear()
	gun_type_claimed_pos.clear()
	gun_group_claimed_pos.clear()
	
	## make an empty dictionary with blank data
	for x : int in SIZE.x:
		for y : int in SIZE.y:
			gun_type_map[ Vector2i(x,y) ] = B2_Gun.TYPE.GUN_TYPE_NONE
	
	## Set RNG stuff
	fuckme = RandomNumberGenerator.new()
	#fuckme.seed = hash("AAAAAAAAAAAAA I HATE THIS") ## Make this "random" function predictive
	var my_seed : int = B2_Config.get_user_save_data( "gunsmap.seed", 69 + 420 )
	if my_seed == 69 + 420:
		push_warning("Gunmap seed not set. throwing a random seed.")
		my_seed = randi()
	#my_seed = 111111 ## DEBUG
	fuckme.seed = my_seed
	# lol, forgot about how frustated I was when writing this.

	## set regions for gun groups, so that similar guns are spawn together.
	for i : B2_Gun.GROUP in B2_Gun.GROUP.values():
		var group_region_pos := Vector2i( fuckme.randi_range(-GROUP_SIZE,GROUP_SIZE), fuckme.randi_range(-GROUP_SIZE,GROUP_SIZE) )
		gun_group_claimed_pos[i] = Vector2i(group_region_pos + SIZE / 2).clamp( Vector2.ZERO, SIZE - Vector2i.ONE )
	
	## create seed points
	for i : B2_Gun.TYPE in B2_Gun.TYPE.values(): # 27 types of guns - Add seed position.
		var region_pos := gun_group_claimed_pos[ GUNMAP_DEFINE[i][GROUP] ]
		var gunman_pos := Vector2i( region_pos + Vector2i( fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD), fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD) ) ).clamp( Vector2.ZERO, SIZE - Vector2i.ONE )
		while gun_type_map[gunman_pos] != B2_Gun.TYPE.GUN_TYPE_NONE: # Reroll position while you have a duplicated position in the map.
			gunman_pos = region_pos + Vector2i( fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD), fuckme.randi_range(-TYPE_SPREAD,TYPE_SPREAD) )
		
		gun_type_map[gunman_pos] = i							## Claimed position on the "global" map.
		gun_type_claimed_pos[i] = [gunman_pos]					## Claimed position stored on the "personal" map.
	
	## expand the initial seed points
	for i : B2_Gun.TYPE in B2_Gun.TYPE.values(): # 27 types of guns - Add seed position.
		var gunman_pos = gun_type_claimed_pos[i].front()
		for d : Vector2i in DIRECTIONS:
			var new_gunman_pos := Vector2i(gunman_pos + d).clamp(Vector2i.ZERO, SIZE - Vector2i.ONE)
			if not gun_type_map[new_gunman_pos] != B2_Gun.TYPE.GUN_TYPE_NONE: # avoid overiding other gun types
				gun_type_map[new_gunman_pos] = i							## Claimed position on the "global" map + offset.
				gun_type_claimed_pos[i].append(new_gunman_pos)					## Claimed position stored on the "personal" map + offset.
		
	## Fill the map
	for i : int in PERMUTATIONS:
		for gun_type : B2_Gun.TYPE in B2_Gun.TYPE.values(): # Do each permutation in parallel for each gun type
			for ii : int in GUNMAP_DEFINE[gun_type][RARITY]: # Apply spread along with rarity
				var set_init_pos := func() -> Vector2i: ## useful callable.
					return gun_type_claimed_pos[gun_type][ fuckme.randi_range(0, gun_type_claimed_pos[gun_type].size() - 1) ]
				var set_rand_dir := func() -> Vector2i: ## useful callable.
					var dir := Vector2i.ZERO
					while dir == Vector2i.ZERO:
						dir = Vector2i( fuckme.randi_range(-1,1), fuckme.randi_range(-1,1) )
					return dir
					
				var initial_pos 	: Vector2i = set_init_pos.call() # intial position is picked at random
				var ray_direction 	: Vector2i = set_rand_dir.call() # direction is picket at random
				var curr_pos		:= initial_pos + ray_direction
				
				## Tries to reach an unnocupied space.
				for step in RAYCAST_TTL:
					if curr_pos.x in range(0,SIZE.x) and curr_pos.y in range(0,SIZE.y): # Check if position is in bounds.
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
	if DEBUG: print( "Gunmap Gen took %s msecs." % str( Time.get_ticks_msec() - start_time ).pad_zeros(4) )
	
static func get_gun_map() -> Texture:
	if gun_type_map.is_empty():
		push_error("Gunmap was no generated previously. doing it now.")
		generate_map()
		
	@warning_ignore("narrowing_conversion")
	var img := Image.create_empty(SIZE.x, SIZE.y, false, Image.FORMAT_RGB8)
	img.fill( Color.BLACK )
	
	# Draw the fucking map.
	for map_pos : Vector2i in gun_type_map:
			var gun_type : B2_Gun.TYPE = gun_type_map[ map_pos ]
			var c_array : Array = GUNMAP_DEFINE[gun_type][COLOR]
			var c : Color = Color.from_hsv( c_array[0], c_array[1], c_array[2] )
			img.set_pixel( map_pos.x, map_pos.y, c )
			#if gun_type != 25: print(gun_type,map_pos)
	return ImageTexture.create_from_image( img )
	
## return a random position from claimed positions for the selected guntype.
static func get_gun_type_pos_from_map( gun_type : B2_Gun.TYPE ) -> Vector2i:
	return gun_type_claimed_pos[gun_type].pick_random() as Vector2i
	
## Get a Gun type and map position from the parent types.
static func get_gun_type_from_parent_position( top_pos : Vector2i, bottom_pos : Vector2i, bias : float ) -> Array:
	# just ate some offbrand icecream. sometimes, life is good.
	var data : Array = [] # Data -> [B2_Gun.TYPE, Vector2i]
	
	var average_pos : Vector2i = Vector2(bottom_pos).lerp( Vector2(top_pos), bias )
	var tries := 0
	
	## sometimes, the position can be somewhere that is not a landmass. search for the nearest landmass.
	while gun_type_map.get(average_pos,B2_Gun.TYPE.GUN_TYPE_NONE) == B2_Gun.TYPE.GUN_TYPE_NONE:
		tries += 1
		for dir : Vector2i in DIRECTIONS: # Tries to find the nearest landmass using offsets.
			if gun_type_map.get(average_pos + dir * tries ,B2_Gun.TYPE.GUN_TYPE_NONE) != B2_Gun.TYPE.GUN_TYPE_NONE:
				average_pos += dir * tries # Found one. Break from the loop and live a happy life.
				break
		if tries > 50: ## Im lost! give up before something bad happens.
			breakpoint
			break
	data = [ gun_type_map[average_pos], average_pos ]
	return data # Data -> [B2_Gun.TYPE, Vector2i]
	
static func get_gun_map_position( dont_care := 2, wpn_name := "", size := Vector2(80,80) ) -> Vector2:
	var fuckyou := RandomNumberGenerator.new()
	fuckyou.seed = hash("IS THIS HAPPENING FOR REAL?????") + hash(dont_care) + hash(wpn_name) ## Make this "random" function predictive
	@warning_ignore("narrowing_conversion")
	return Vector2( fuckyou.randi_range(0, size.x), fuckyou.randi_range(0, size.y) )
