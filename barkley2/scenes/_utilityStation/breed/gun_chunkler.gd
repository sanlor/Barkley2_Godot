@tool
extends Control
# Fun name. Controls the gun's chunklets during the DNA fusing

#const GUN_DNA_SHADER_MATERIAL = preload("res://barkley2/scenes/_utilityStation/breed/gun_dna_shader_material.tres")
const FRANKIE_GUNS = preload("res://barkley2/assets/b2_original/guns/FrankieGuns.png")
const GUNCELL := Vector2( B2_Gun.GUNWIDTH, B2_Gun.GUNHEIGHT )

var chunk_size			:= Vector2(4.0, 4.0)
@warning_ignore("integer_division")
var chunks_per_lines 	:= B2_Gun.GUNWIDTH / chunk_size.x
@warning_ignore("integer_division")
var chunks_per_row 		:= B2_Gun.GUNHEIGHT / chunk_size.y
 
var stretch := 1.0

@export var debug := true
@export var my_target : Marker2D
@export var gun_pos				:= Vector2(0.0,0.0)
@export_tool_button("Gen Chunks") var gen : Callable = gen_chunks

func _ready() -> void:
	if not Engine.is_editor_hint():
		#gen_chunks()
		pass

func gen_chunks() -> void:
	var time := Time.get_ticks_msec()
	size = GUNCELL * stretch
	
	for c in get_children():
		c.queue_free()
		
	for x in chunks_per_lines:
		for y in chunks_per_row:
			var progress 		:= Vector2(float(x) / float(chunks_per_lines), float(y) / float(chunks_per_row))
			var target_rect 	:= Rect2i( (gun_pos * GUNCELL) + (Vector2(x,y) * chunk_size) , chunk_size )
			
			## Fuck around with the image
			@warning_ignore("narrowing_conversion")
			var my_gun_image = Image.create_empty(chunk_size.x, chunk_size.y, false, Image.FORMAT_RGBA8)
			my_gun_image.blit_rect( FRANKIE_GUNS.get_image(), target_rect, Vector2.ZERO )
			
			## Avoid making empty texture nodes. this slows down the animation.
			if not is_clear(my_gun_image):
				## Make Chunk node
				@warning_ignore("narrowing_conversion")
				my_gun_image.resize(chunk_size.x * stretch, chunk_size.y * stretch, Image.INTERPOLATE_NEAREST)
				var chunk 		:= TextureRect.new()
				chunk.position 	= Vector2(x,y) * chunk_size * stretch
				chunk.size 		= chunk_size * stretch
				chunk.texture 	= ImageTexture.create_from_image( my_gun_image )
				add_child( chunk )
			else:
				#print("Empty")
				pass
			
	if debug:
		print( "Chunklets: %s - Time: %s msecs." % [str( get_children().size() ), Time.get_ticks_msec() - time] )
	
	## Failed attept using shaders.
	#for x in chunks_per_lines:
		#for y in chunks_per_row:
			#var progress := Vector2(float(x) / float(chunks_per_lines), float(y) / float(chunks_per_row))
			#var chunk := ColorRect.new()
			#chunk.position = Vector2(x,y) * chunk_size
			#chunk.size = chunk_size # GUNCELL
			#chunk.material = GUN_DNA_SHADER_MATERIAL.duplicate()
			#chunk.material.set_shader_parameter( "atlas_pos", gun_pos + (progress * GUNCELL) )
			##chunk.material.set_shader_parameter( "chunk_offset", (progress * GUNCELL) / GUNCELL )
			#chunk.material.set_shader_parameter( "chunk_offset", Vector2.ZERO )
			#chunk.material.set_shader_parameter( "chunk_size", chunk_size / GUNCELL )
			#add_child(chunk)

## small brain moment. how do I check if a image is full of transparent pixels?
func is_clear( img : Image ) -> bool:
	return img.get_data().count(0) == 64

func _suck_chunks() -> void:
	if not my_target:
		push_error("Target not set. Aborting...")
		return
		
	var chunks := get_children()
	chunks.shuffle()
	
	for c in chunks:
		## is there any downsides of creating this many tweeners?
		var t := create_tween()
		t.tween_interval( randf() * 2 )
		t.tween_property( c, "global_position", my_target.global_position, randf_range(0.4,0.6) ).set_ease(Tween.EASE_OUT_IN)
		t.tween_property( c, "modulate", Color.TRANSPARENT, 0.25 )
		t.tween_interval( randf() )
		t.tween_callback( c.queue_free )
