extends B2_DOOR_PARENT

@export var is_open := false

@onready var sensor_shape: 			CollisionShape2D = $door_sensor/sensor_shape
@onready var locked_panel: 			PanelContainer = $locked_panel
@onready var locked_text_label: 	Label = $locked_panel/MarginContainer/locked_text

var tween : Tween

func _ready() -> void:
	_door_setup()
	locked_panel.hide()
	
	if is_open:
		door_open( true )
		door_block.get_child( 0 ).disabled = true
	else:
		door_close( true )
		door_block.get_child( 0 ).disabled = false
		
	door_sensor.body_entered.connect( detect_player_enter )
	door_sensor.body_exited.connect( detect_player_exit )

func detect_player_exit( body ):
	if body is B2_PlayerCombatActor:
		if locked:
			if not is_open:
				hide_locked_message()
			return
		else:
			door_close()

func detect_player_enter( body ):
	if body is B2_PlayerCombatActor:
		if locked:
			if not is_open:
				show_locked_message()
			return
		else:
			door_open()
		
func show_locked_message():
	locked_text_label.text = locked_text
	var spr_size := sprite_frames.get_frame_texture( animation, 0 ).get_size().x # should return the sprite width
	locked_panel.position.x = -(locked_panel.size.x / 2.0) + spr_size / 2.0 # set the panel centered in the middle of the sprite
	
	if is_instance_valid(tween):
		tween.kill()
		
	locked_panel.show()
	locked_panel.modulate.a = 0.0
	
	tween = create_tween()
	tween.tween_property(locked_panel, "modulate:a", 1.0, 0.15)

func hide_locked_message():
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property(locked_panel, "modulate:a", 0.0, 0.15)
	tween.tween_callback( locked_panel.hide )
