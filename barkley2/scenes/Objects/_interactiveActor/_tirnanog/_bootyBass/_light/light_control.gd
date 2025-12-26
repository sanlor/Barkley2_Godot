extends Node2D

const LIGHT_FLASH 		:= preload("uid://kha3cuwbvp1t")
const SPOT_LIGHT_SPIN 	:= preload("uid://cwfcat7g51xc3")

@onready var flash_timer: Timer = $flash_timer

var enabled 		:= true
var flash_enabled 	:= true
var spin_enabled	:= true

var flash_time := 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_timer( time : float ) -> void:
	flash_time = time
	flash_timer.wait_time = flash_time

func _on_flash_timer_timeout() -> void:
	if enabled:
		## Godot has a hard limit for 14 light sources.
		if get_children().size() >= 10:
			return
			
		if flash_enabled:
			for i in [1,1,1,2,3] .pick_random():
				create_light_flash()
		
		if spin_enabled:
			if randf() > 0.75:
				create_light_spot()

func disable_light() -> void:
	enabled = false
	
func enable_light() -> void:
	enabled = true

func create_light_spot() -> void:
	var l := SPOT_LIGHT_SPIN.instantiate()
	add_child( l, true )
	#l.global_position = Vector2(384.0 / 2.0, 240.0 / 2.0 )

func create_light_flash() -> void:
	var l := LIGHT_FLASH.instantiate()
	l.set_type( randi_range(0,2) )
	add_child( l, true )
	#l.global_position = Vector2(384.0 / 2.0, 240.0 / 2.0 )
	l.global_position.x += randf_range( -250, 250 )
	l.global_position.y += randf_range( -180, 180 )
