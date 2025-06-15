extends RefCounted
class_name B2_Gunmap
## Check Gunsmap("draw")
# This is very stupid. This draws a little map related to the gun lineage. As of 14/06/25, lineage does not work. Even now I have no idea how this map is generated.
# What the fuck. check line 417. what kind of drugs where these guys on? 

## NOTE Motherfucker, this function uses a file called "gunsmap.ini". That does this function even does??????? is this important?

enum {TOP, BOTTOM, OCCUPIED}

static func get_gun_map( size := Vector2(80,80) ) -> Texture:
	@warning_ignore("narrowing_conversion")
	var img := Image.create_empty(size.x, size.y, false, Image.FORMAT_RGB8)
	img.fill( Color.BLACK )
	# I dont give a fuck anymore. Porting this mess of a code not knowing how it should work is not fun
	var fuckfuckfuck := [] ## Array of noise stuff
	var fuckme := RandomNumberGenerator.new()
	fuckme.seed = hash("AAAAAAAAAAAAA I HATE THIS") ## Make this "random" function predictive
	
	for i in B2_Gun.GUNTYPES: # 27 types of guns
		var stopstopstop := FastNoiseLite.new()
		stopstopstop.frequency = 0.02
		stopstopstop.noise_type = FastNoiseLite.TYPE_CELLULAR
		stopstopstop.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN
		stopstopstop.seed = fuckme.randi()
		fuckfuckfuck.append( stopstopstop )
		
	# Draw the fucking map.
	for noise : FastNoiseLite in fuckfuckfuck:
		var c := Color( fuckme.randf(), fuckme.randf(), fuckme.randf() )
		for x in size.x:
			for y in size.y:
				if noise.get_noise_2d(x, y) > -0.4: ## Fuck you. -0.4 works for some reason.
					@warning_ignore("narrowing_conversion")
					img.set_pixel( x, y, c )
				
	return ImageTexture.create_from_image( img )
	
static func get_gun_map_position( dont_care := 2, wpn_name := "", size := Vector2(80,80) ) -> Vector2:
	var fuckyou := RandomNumberGenerator.new()
	fuckyou.seed = hash("IS THIS HAPPENING FOR REAL?????") + hash(dont_care) + hash(wpn_name) ## Make this "random" function predictive
	@warning_ignore("narrowing_conversion")
	return Vector2( fuckyou.randi_range(0, size.x), fuckyou.randi_range(0, size.y) )
