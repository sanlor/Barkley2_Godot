@tool
extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var no_maps_lbl: Label = $ColorRect/no_maps_lbl
@onready var map_name: Label = $ColorRect/map_name

@onready var prev_map: TextureButton = $ColorRect/prev_map
@onready var next_map: TextureButton = $ColorRect/next_map

@onready var exit_button: TextureButton = $ColorRect/exit_button
@onready var exit_spr: AnimatedSprite2D = $ColorRect/exit_button/exit_spr

@onready var fade_effect: ColorRect = $ColorRect/fade_effect

@onready var map_itself: TextureRect = $ColorRect/map_itself

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const text_size := 5440.0
const map_size := 320.0
const map_speed := 0.15
var tween : Tween

var avaiable_maps := []

var selected_map := 0 :
	set(i):
		selected_map = wrapi( i, 0, avaiable_maps.size() )

func _ready() -> void:
	layer = B2_Config.MAP_LAYER
	
	no_maps_lbl.text = Text.pr("No maps available.")
	exit_spr.frame = 0
	fade_effect.modulate.a = 0.0
	color_rect.modulate.a = 0.0
	
	avaiable_maps = B2_Map.get_all()
	
	# No maps avaiable, show nothing.
	if avaiable_maps.is_empty():
		prev_map.queue_free()
		next_map.queue_free()
		map_itself.queue_free()
		map_name.text = Text.pr( "No maps... :(")
		
	# only one map avaiable, remove arrow keys.
	elif avaiable_maps.size() == 1:
		prev_map.queue_free()
		next_map.queue_free()
		no_maps_lbl.hide()
		change_map()
		
	else:
		no_maps_lbl.hide()
		change_map()
		#avaiable_maps.sort()
		
	animation_player.play("show_myself")
	audio_stream_player.play()
	
func change_map() -> void:
	# get map name from the directory
	map_name.text = Text.pr( B2_Map.map_directory[ avaiable_maps[selected_map] ] )
	map_itself.texture.region.position.x = avaiable_maps[selected_map] * map_size

func _on_exit_button_mouse_entered() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(exit_spr, "frame", 7, 0.15 )
	tween.tween_property(fade_effect, "modulate:a", 0.75, 0.15 )

func _on_exit_button_mouse_exited() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(exit_spr, "frame", 0, 0.15 )
	tween.tween_property(fade_effect, "modulate:a", 0.0, 0.15 )

func _on_prev_map_pressed() -> void:
	var cur_p := map_itself.texture.region.position.x as float
	var tar_p := cur_p - map_size as float
	tar_p = wrap(tar_p, 0, text_size)
	
	selected_map -= 1
	
	var t := create_tween()
	t.tween_callback( prev_map.set_disabled.bind(true) )
	t.tween_callback( next_map.set_disabled.bind(true) )
	
	#t.tween_property( map_itself, "texture:region:position:x", tar_p, map_speed )
	t.tween_property( map_itself, "position:x", 320 + 2, map_speed )
	t.tween_callback( map_itself.set_position.bind( Vector2( -320, 27 ) ) )
	t.tween_callback( change_map )
	t.tween_property( map_itself, "position:x", 32, map_speed )
	
	t.tween_callback( prev_map.set_disabled.bind(false) )
	t.tween_callback( next_map.set_disabled.bind(false) )

func _on_next_map_pressed() -> void:
	var cur_p := map_itself.texture.region.position.x as float
	var tar_p := cur_p + map_size as float
	tar_p = wrap(tar_p, 0, text_size)
	
	selected_map += 1
	
	var t := create_tween()
	t.tween_callback( prev_map.set_disabled.bind(true) )
	t.tween_callback( next_map.set_disabled.bind(true) )
	
	#t.tween_property( map_itself, "texture:region:position:x", tar_p, map_speed )
	t.tween_property( map_itself, "position:x", -320, map_speed )
	t.tween_callback( map_itself.set_position.bind( Vector2( 320 * 2, 27 ) ) )
	t.tween_callback( change_map )
	t.tween_property( map_itself, "position:x", 32, map_speed )
	
	t.tween_callback( prev_map.set_disabled.bind(false) )
	t.tween_callback( next_map.set_disabled.bind(false) )

func _on_exit_button_pressed() -> void:
	B2_Screen.hide_map_screen() # gracefully close the screen
	
func hide_menu():
	animation_player.play("hide_myself")
	audio_stream_player.play()
	return await animation_player.animation_finished
