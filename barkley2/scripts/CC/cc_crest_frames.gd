extends TextureRect

@onready var crest_canvas = $crest_canvas

var image_size 		:= Vector2(224,156)
var image_canvas 	: Image
var brush_size		:= Vector2( 6, 6 )

var sound_playing := false
var sound_stream : AudioStreamPlayer

func _ready():
	@warning_ignore("narrowing_conversion")
	image_canvas = Image.create( image_size.x, image_size.y, false, Image.FORMAT_RGBA8)
	image_canvas.fill( Color.TRANSPARENT )

func _physics_process(_delta):
	if Input.is_action_pressed("Action"):
		if Rect2(global_position, image_size).has_point( get_global_mouse_position() ):
			var brush_pos := get_global_mouse_position() - global_position
			for x in brush_size.x:
				for y in brush_size.x:
					if randf() > 0.5:
						continue
					image_canvas.set_pixelv( brush_pos + Vector2(x,y) - Vector2(brush_size.x / 2,brush_size.y / 2), get_parent().selected_color )
					
			crest_canvas.texture = ImageTexture.create_from_image( image_canvas )
			if not sound_playing:
				sound_playing = true
				sound_stream = B2_Sound.play("sn_cc_crest_spray", 0.0, false, 10)
			
			if not get_parent().drawn_something:
				get_parent().drawn_something = true
				
	if Input.is_action_just_released("Action"):
		sound_playing = false
		B2_Sound.stop(sound_stream)
		sound_stream = null
		
	if Input.is_action_pressed("Holster"):
		if Rect2(global_position, image_size).has_point( get_global_mouse_position() ):
			var brush_pos := get_global_mouse_position() - global_position
			for x in brush_size.x:
				for y in brush_size.x:
					image_canvas.set_pixelv( brush_pos + Vector2(x,y) - Vector2(brush_size.x / 2,brush_size.y / 2), Color.TRANSPARENT )
			crest_canvas.texture = ImageTexture.create_from_image( image_canvas )
			if not sound_playing:
				sound_playing = true
				sound_stream = B2_Sound.play("sn_cc_crest_wipe", 0.0, false, 10)
				
	if Input.is_action_just_released("Holster"):
		sound_playing = false
		B2_Sound.stop(sound_stream)
		sound_stream = null
		
func get_crest() -> PackedByteArray:
	return image_canvas.get_data()
