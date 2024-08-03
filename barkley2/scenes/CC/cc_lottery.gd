extends Control

signal lottery_selected

const CC_LOTTERY_CHECKMARK = preload("res://barkley2/scenes/CC/cc_lottery_checkmark.tscn")

@onready var done_button = $done_button
@onready var animation_player = $AnimationPlayer
@onready var lottery_card = $lottery_card

var selected_numbers := []

func _ready():
	done_button.disabled = true
			
func show_lottery():
	animation_player.play( "show" )
	await animation_player.animation_finished
	done_button.disabled = false
	
	## Add buttons
	for j in 3:
		for i in 6:
			var button := Button.new()
			button.size = Vector2( 24, 16 )
			button.position = Vector2( 88 + i * 32, 96 + j * 24 )
			button.flat = true
			add_child( button )
			button.button_down.connect( func(): place_checkmark( button.position, i * j ); button.queue_free() )

			
func place_checkmark(pos : Vector2, number : int):
	var check = CC_LOTTERY_CHECKMARK.instantiate()
	lottery_card.add_child( check )
	check.global_position = pos + Vector2( 24, 16 ) / 2
	
	selected_numbers.append( number )
	var check_sounds := ["sn_cc_lottery_pen1", "sn_cc_lottery_pen2", "sn_cc_lottery_pen3"]
	B2_Sound.play( check_sounds.pick_random() )
	
	
func _on_done_button_button_down():
	B2_Sound.play( "sn_cc_button_accept" )
	B2_Playerdata.Quest("playerCCLottery", var_to_str(selected_numbers) );
	B2_Playerdata.character_lottery = selected_numbers
	done_button.release_focus()
	
	animation_player.play( "hide" )
	await animation_player.animation_finished
	lottery_selected.emit()
	
	# queue_free() # should we queue it free?
