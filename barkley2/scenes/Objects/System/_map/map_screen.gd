#@tool
extends CanvasLayer

const MAP_ICONS := {
	"sMapIconCyberdwarf" 	: preload("uid://c8ef176trmf7s"),
	"sMapIconDossier" 		: preload("uid://6mpynkhuh2jj"),
	"sMapIconExit" 			: preload("uid://dhjjm87o3widk"),
	"sMapIconGrapes" 		: preload("uid://bhq5imqsy4xrv"),
	"sMapIconHelper" 		: preload("uid://bb6form3ey553"),
	"sMapIconHoopz" 		: preload("uid://b12jlt03j186s"),
	"sMapIconQuestion" 		: preload("uid://bpwtf5ornfu3x"),
	"sMapIconRent" 			: preload("uid://cmybrdghyngxo"),
	"sMapIconSewers" 		: preload("uid://cvowfh0pjkm71"),
	"sMapIconTutorial" 		: preload("uid://56jex3w851t4"),
}

## Index for the map icon data.
enum {ICON_NAME,ICON_X,ICON_Y,ICON_CONDITIONS}

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var no_maps_lbl: Label = $ColorRect/no_maps_lbl
@onready var map_name: Label = $ColorRect/B2_Border/map_name

@onready var prev_map: TextureButton = $ColorRect/prev_map
@onready var next_map: TextureButton = $ColorRect/next_map

@onready var exit_button: TextureButton = $ColorRect/exit_button
@onready var exit_spr: AnimatedSprite2D = $ColorRect/exit_button/exit_spr

@onready var fade_effect: ColorRect = $ColorRect/fade_effect

@onready var map_itself: TextureRect = $ColorRect/map_itself

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const text_size 	:= 5440.0
const map_size 		:= 320.0
const map_speed 	:= 0.15
var tween 			: Tween

var time			:= 0.0

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
	cleanup_map_icons()
	map_name.text = Text.pr( B2_Map.get_map_name( int(avaiable_maps[selected_map]) ) ) 	# get map name from the directory
	map_itself.texture.region.position.x = int(avaiable_maps[ selected_map ]) * map_size
	populate_map_icons()

func cleanup_map_icons() -> void:
	for c in map_itself.get_children():
		if c: c.queue_free()
	
func populate_map_icons() -> void:
	var my_map_icons : Array = B2_Map.get_map_icons( B2_Map.get_map_name( int(avaiable_maps[selected_map]) ) )
	
	## Lets go, lets check for all conditions to see it we can place a map icon.
	for icon : Array in my_map_icons:
		var can_place_icon := true
		
		for condition_array : Array in icon[ICON_CONDITIONS]: ## check all conditions. if any is false, do not place icon.
			if condition_array.is_empty():
				continue
				
			var operand1 	: String = condition_array[0]
			var condition 	: String = condition_array[1]
			var operand2 	: String = condition_array[2]
			
			var this_room = get_tree().current_scene
			if not this_room is B2_ROOMS: ## If its not B2_ROOMS, quit.
				can_place_icon = false
				break
			
			if operand1 == "room":				operand1 = this_room.get_room_name()
			elif operand1 == "area":			operand1 = this_room.get_room_area()
			elif operand1 == "x":				operand1 = str( int(B2_CManager.o_hoopz.global_position.x) )
			elif operand1 == "y":				operand1 = str( int(B2_CManager.o_hoopz.global_position.y) )
			else:								operand1 = str( B2_Playerdata.Quest(operand1) )
			
			match condition:
				"==","=":	if not operand1 == operand2: 	can_place_icon = false; break
				"!=":		if not operand1 != operand2: 	can_place_icon = false; break
				">=":		if not operand1 >= operand2: 	can_place_icon = false; break
				"<=":		if not operand1 <= operand2: 	can_place_icon = false; break
				">":		if not operand1 > operand2: 	can_place_icon = false; break
				"<":		if not operand1 < operand2: 	can_place_icon = false; break
		
		if can_place_icon:
			var icon_texture : Texture2D = MAP_ICONS[ icon[ICON_NAME] ]
			var icon_sprite := Sprite2D.new()
			icon_sprite.texture = icon_texture
			icon_sprite.position = Vector2( int(icon[ICON_X]), int(icon[ICON_Y]) )
			map_itself.add_child( icon_sprite )
			
	#breakpoint

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

func _physics_process(delta: float) -> void:
	time += 5.0 * delta
	
	if is_instance_valid(map_itself):
		for c in map_itself.get_children():
			if c is Node2D:
				c.modulate.a = sin(time) + 1.25
		
	
