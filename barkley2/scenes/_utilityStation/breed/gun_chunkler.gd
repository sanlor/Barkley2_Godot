@tool
extends Control
# Fun name. Controls the gun's chunklets.

#const GUN_DNA_SHADER_MATERIAL = preload("res://barkley2/scenes/_utilityStation/breed/gun_dna_shader_material.tres")
const FRANKIE_GUNS = preload("res://barkley2/assets/b2_original/guns/FrankieGuns.png")

const GUNCELL := Vector2( B2_Gun.GUNWIDTH, B2_Gun.GUNHEIGHT )
@warning_ignore("integer_division")
var chunks_per_lines 	:= B2_Gun.GUNWIDTH / 4
@warning_ignore("integer_division")
var chunks_per_row 		:= B2_Gun.GUNHEIGHT / 4
var chunk_size			:= Vector2(4.0, 4.0) # Vector2(GUNCELL.x / float(chunks_per_lines), GUNCELL.y / float(chunks_per_row) )
@export var gun_pos				:= Vector2(0.0,0.0)
@export_tool_button("Gen Chunks") var gen : Callable = _gen_chunks

func _ready() -> void:
	if not Engine.is_editor_hint():
		_gen_chunks()

func _gen_chunks() -> void:
	size = GUNCELL
	
	for c in get_children():
		c.queue_free()
		
	for x in chunks_per_lines:
		for y in chunks_per_row:
			var progress 		:= Vector2(float(x) / float(chunks_per_lines), float(y) / float(chunks_per_row))
			var target_rect 	:= Rect2i( (gun_pos * GUNCELL) + (Vector2(x,y) * chunk_size) , chunk_size )
			
			## Fuck around withthe image
			@warning_ignore("narrowing_conversion")
			var my_gun_image = Image.create_empty(chunk_size.x, chunk_size.y, false, Image.FORMAT_RGBA8)
			my_gun_image.blit_rect( FRANKIE_GUNS.get_image(), target_rect, Vector2.ZERO )
			
			## Avoid making empty texture nodes. this slows down the animation.
			if not is_clear(my_gun_image):
				## Make Chunk node
				var chunk 		:= TextureRect.new()
				chunk.position 	= Vector2(x,y) * chunk_size
				chunk.size 		= chunk_size
				chunk.texture 	= ImageTexture.create_from_image( my_gun_image )
				add_child( chunk )
			else:
				#print("Empty")
				pass
			
	#print( get_children().size() )
	
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

func _suck_chunks(pos : Vector2) -> void:
	var chunks := get_children()
	chunks.shuffle()
	
	for c in chunks:
		## is there any downsides of creating this many tweeners?
		var t := create_tween()
		t.tween_interval( randf() )
		t.tween_property( c, "position", pos, 0.4 )
		t.tween_property( c, "modulate", Color.TRANSPARENT, 0.1 )
		t.tween_interval( randf() )
		t.tween_callback( c.queue_free )
	
func _suck_chunks_downward() -> void:
	pass

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("Action"):
			_suck_chunks(Vector2(GUNCELL.x / 2, 0))
		if Input.is_action_just_pressed("Holster"):
			_suck_chunks(Vector2(GUNCELL.x / 2, GUNCELL.y))
