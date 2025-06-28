extends Control

signal finished_animation

@onready var dnet_screen: CanvasLayer = $".."
@onready var bg_border: 		ColorRect = $bg_border
@onready var bg: 				ColorRect = $bg
@onready var loading_screen: 	TextureRect = $loading_screen
@onready var registration: 		Control = $registration
@onready var logging_in: 		Control = $logging_in

var dnet_account_name 	:= "xXBasketBall69Xx"
var goal_password 		:= "Bball4ever"

func begin_animation() -> void:
	bg.show()
	bg_border.show()
	loading_screen.hide()
	registration.hide()
	logging_in.hide()
	
	## C64 effect
	bg_border.begin_animation()
	if B2_DNET.Store("dwarfnetAccount") == 0:
		## First time login, show the fulll animation.
		
		get_parent().play_random_music()
		loading_screen.show()
		@warning_ignore("integer_division")
		for i in 286:
			loading_screen.tiles_to_draw += 1
			loading_screen.queue_redraw()
			await get_tree().create_timer( randf() * 0.125 ).timeout
		
		await get_parent().key_pressed
		get_parent().stop_music()
		loading_screen.hide()
	else:
		await get_tree().create_timer( randf_range(1.0,3.0) ).timeout
		
	bg_border.finish_animation()
	## Registration page
	bg.hide()
	registration.show()
	registration.begin_animation()
	var choice : bool = await registration.finished_animation
	
	## User clicked in "register"
	if choice:
		logging_in.show()
		logging_in.begin_animation()
		await logging_in.finished_animation
	## User clicked in "exit"
	else:
		dnet_screen.close_dnet()
		
	finish_animation()
	
func finish_animation() -> void:
	finished_animation.emit()
