@tool
extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@onready var no_notes_lbl: Label = $ColorRect/no_notes_lbl
@onready var note_name: Label = $ColorRect/note_name
@onready var note_itself: TextureRect = $ColorRect/note_itself
@onready var fade_effect: ColorRect = $ColorRect/fade_effect
@onready var prev_note: TextureButton = $ColorRect/prev_note
@onready var next_note: TextureButton = $ColorRect/next_note
@onready var exit_button: TextureButton = $ColorRect/exit_button
@onready var exit_spr: AnimatedSprite2D = $ColorRect/exit_button/exit_spr
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


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
	
	no_notes_lbl.text = Text.pr("No notes available.")
	exit_spr.frame = 0
	fade_effect.modulate.a = 0.0
	color_rect.modulate.a = 0.0
	
	avaiable_maps = B2_Map.get_all()
	
	# No maps avaiable, show nothing.
	if avaiable_maps.is_empty():
		prev_note.queue_free()
		next_note.queue_free()
		note_itself.queue_free()
		note_name.text = Text.pr( "No notes... :(")
		
	# only one map avaiable, remove arrow keys.
	elif avaiable_maps.size() == 1:
		prev_note.queue_free()
		next_note.queue_free()
		no_notes_lbl.hide()
		change_map()
		
	else:
		no_notes_lbl.hide()
		change_map()
		#avaiable_maps.sort()
		
	animation_player.play("show_myself")
	audio_stream_player.play()
	
func change_map() -> void: ## CRITICAL Need to change this to support the mental way B2 handles Notes.
	# get note name from the directory
	note_name.text = Text.pr( B2_Map.map_directory[ avaiable_maps[selected_map] ] )
	note_itself.texture.region.position.x = avaiable_maps[selected_map] * map_size

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

func _on_prev_note_pressed() -> void:
	var cur_p := note_itself.texture.region.position.x as float
	var tar_p := cur_p - map_size as float
	tar_p = wrap(tar_p, 0, text_size)
	
	selected_map -= 1
	
	var t := create_tween()
	t.tween_callback( prev_note.set_disabled.bind(true) )
	t.tween_callback( next_note.set_disabled.bind(true) )
	
	#t.tween_property( note_itself, "texture:region:position:x", tar_p, map_speed )
	t.tween_property( note_itself, "position:x", 320 + 2, map_speed )
	t.tween_callback( note_itself.set_position.bind( Vector2( -320, 27 ) ) )
	t.tween_callback( change_map )
	t.tween_property( note_itself, "position:x", 32, map_speed )
	
	t.tween_callback( prev_note.set_disabled.bind(false) )
	t.tween_callback( next_note.set_disabled.bind(false) )

func _on_next_note_pressed() -> void:
	var cur_p := note_itself.texture.region.position.x as float
	var tar_p := cur_p + map_size as float
	tar_p = wrap(tar_p, 0, text_size)
	
	selected_map += 1
	
	var t := create_tween()
	t.tween_callback( prev_note.set_disabled.bind(true) )
	t.tween_callback( next_note.set_disabled.bind(true) )
	
	#t.tween_property( note_itself, "texture:region:position:x", tar_p, map_speed )
	t.tween_property( note_itself, "position:x", -320, map_speed )
	t.tween_callback( note_itself.set_position.bind( Vector2( 320 * 2, 27 ) ) )
	t.tween_callback( change_map )
	t.tween_property( note_itself, "position:x", 32, map_speed )
	
	t.tween_callback( prev_note.set_disabled.bind(false) )
	t.tween_callback( next_note.set_disabled.bind(false) )

func _on_exit_button_pressed() -> void:
	B2_Screen.hide_map_screen() # gracefully close the screen
	
func hide_menu():
	animation_player.play("hide_myself")
	audio_stream_player.play()
	return await animation_player.animation_finished
