extends ColorRect

signal finished

@onready var o_mg_booty_minigame: Node = $"../.."

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var r_ado_result_label: Label = $result_box/adoration_box/r_ado_result_label
@onready var r_too_result_label: Label = $result_box/toot_box/r_too_result_label
@onready var r_var_result_label: Label = $result_box/variety_box/r_var_result_label
@onready var r_quo_result_label: Label = $quot_box/r_quo_result_label

@onready var final_result_label: Label = $final_result_label
@onready var press_button_label: Label = $press_button_label

# Game result
var adoration				:= 0		# "Adoration"
var buttons_pressed			:= 0		# "Toot Intensity"
var variety_total			:= 0		# "Variety"
var reward_from_minigame 	:= 0		# "Booty Quotient"

var is_waiting_input := false

func _ready() -> void:
	press_button_label.hide()
	final_result_label.hide()

func populate_data() -> void:
	# Float to int
	adoration 			= o_mg_booty_minigame.adoration
	buttons_pressed 	= o_mg_booty_minigame.buttons_pressed
	variety_total 		= o_mg_booty_minigame.variety_total
	
	_update_labels()

func begin_sequence() -> void:
	populate_data()
	animation_player.play("finish_sequence")

func finish_sequence() -> void:
	## TODO
	push_warning("TODO")
	press_button_label.modulate = Color.TRANSPARENT
	var tween := create_tween()
	for i in adoration:
		tween.tween_callback( _transfer_adoration ).set_delay(0.025)
	tween.tween_interval( 1.0 )
	for i in buttons_pressed:
		tween.tween_callback( _transfer_buttons_pressed ).set_delay(0.025)
	tween.tween_interval( 1.0 )
	for i in variety_total:
		tween.tween_callback( _transfer_variety_total ).set_delay(0.025)
	tween.tween_interval( 2.0 )
	tween.tween_callback( press_button_label.show )
	tween.tween_callback( final_result_label.show )
	tween.parallel().tween_property( press_button_label, "modulate", Color.WHITE, 1.0 )
	tween.tween_callback( set.bind("is_waiting_input", true) )
	await tween.finished
	
	final_result_label.show()
	# o_mg_booty_minigame create line 58 and draw line 132
	if reward_from_minigame <= 25:			final_result_label.text = Text.pr("Toot failure")
	elif reward_from_minigame <= 75:		final_result_label.text = Text.pr("Toot amateur")
	elif reward_from_minigame <= 128:		final_result_label.text = Text.pr("Toot dork")
	elif reward_from_minigame <= 200:		final_result_label.text = Text.pr("Toot hobbyist")
	elif reward_from_minigame <= 300:		final_result_label.text = Text.pr("Toot slammer")
	else:									final_result_label.text = Text.pr("Tootlord")
	
	## Play fanfare
	B2_Sound.play("sn_bb_fanfare")
	
	# Update the almighty variable, for fuck sake.
	o_mg_booty_minigame.reward_from_minigame = reward_from_minigame
	
	#finished.emit()

func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton or event is InputEventKey or event is InputEventMouseButton) and is_waiting_input:
		if event.is_pressed():
			finished.emit()
			is_waiting_input = false

func _transfer_adoration() -> void:
	adoration -= 1
	reward_from_minigame += 1
	_update_labels()
	if not audio_stream_player.playing:
		audio_stream_player.play()
		
func _transfer_buttons_pressed() -> void:
	buttons_pressed -= 1
	reward_from_minigame += 1
	_update_labels()
	if not audio_stream_player.playing:
		audio_stream_player.play()
		
func _transfer_variety_total() -> void:
	variety_total -= 1
	reward_from_minigame += 1
	_update_labels()
	if not audio_stream_player.playing:
		audio_stream_player.play()

func _update_labels() -> void:
	r_ado_result_label.text = str(adoration)
	r_too_result_label.text = str(buttons_pressed)
	r_var_result_label.text = str(variety_total)
	r_quo_result_label.text = str(reward_from_minigame)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	finish_sequence()

# flash Label
func _physics_process(_delta: float) -> void:
	if is_waiting_input:
		var color_offset : float = 0.1
		final_result_label.modulate.h = clampf( final_result_label.modulate.h + color_offset * 1.00, 0.0, 1.0 )
		#final_result_label.modulate.g = clampf( final_result_label.modulate.g + color_offset * 0.75, 0.0, 1.0 )
		#final_result_label.modulate.b = clampf( final_result_label.modulate.b + color_offset * 0.50, 0.0, 1.0 )
