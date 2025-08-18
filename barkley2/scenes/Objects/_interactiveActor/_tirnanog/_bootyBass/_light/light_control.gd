extends Node2D

const LIGHT_FLASH 		:= preload("uid://kha3cuwbvp1t")
const SPOT_LIGHT_SPIN 	:= preload("uid://cwfcat7g51xc3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_flash_timer_timeout() -> void:
	## Godot has a hard limit for 14 light sources.
	if get_children().size() >= 10:
		return
		
	for i in [1,1,1,2,3] .pick_random():
		create_light_flash()
	
	if randf() > 0.75:
		create_light_spot()

func create_light_spot() -> void:
	var l := SPOT_LIGHT_SPIN.instantiate()
	add_child( l, true )
	#l.global_position = Vector2(384.0 / 2.0, 240.0 / 2.0 )

func create_light_flash() -> void:
	var l := LIGHT_FLASH.instantiate()
	add_child( l, true )
	#l.global_position = Vector2(384.0 / 2.0, 240.0 / 2.0 )
	l.global_position.x += randf_range( -250, 250 )
	l.global_position.y += randf_range( -180, 180 )
