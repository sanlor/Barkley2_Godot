extends Control

## Annoying noise on the original.
## the BG is a pretty clever effect

signal cranial_anim_finished
signal handscan_finished
signal mouse_clicked # scan finished, waiting for a mouse click
signal data_sent
signal results_shown

const S_CC_HAND_SCANNER_TECHNO_GRID = preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_techno_grid_0.png")
const S_CC_HAND_SCANNER_EFFECT := [
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_0.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_1.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_2.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_3.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_4.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_5.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_6.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_effect_7.png"),
]
var anim_timer_default := 0.5
var anim_timer := 0.0
var cc_hand_scanner_effect_index := 0 :
	set(i):
		cc_hand_scanner_effect_index = i
		cc_hand_scanner_effect_index = wrap( cc_hand_scanner_effect_index, 0, 8 )

var hand_bg_flip := false
var hand_bg_color := Color.WHITE

var scan_finished := false

@onready var animation_player = $AnimationPlayer
@onready var togtech_cranial = $togtech_cranial
@onready var hand_bg = $hand_scanner_device/hand_bg
@onready var hand_scanner_device = $hand_scanner_device
@onready var beam = $hand_scanner_device/beam
@onready var end_scan_message = $hand_scanner_device/end_scan_message

@onready var cc_transition_scanner = $cc_transition_scanner

@onready var hand_scanner_results = $hand_scanner_results

func _ready():
	end_scan_message.global_position = Vector2(192, 120 + 20) - Vector2( 30, 21 )
	hand_scanner_results.hide()
	pass

func show_togtech_cranial():
	togtech_cranial.show()
	animation_player.play("cranial_scan")
	await animation_player.animation_finished
	togtech_cranial.hide()
	cranial_anim_finished.emit()
	
func show_handscanner():
	animation_player.play("show_handscanner")
	B2_Sound.play( "sn_cc_scanner_assemble" )
	await animation_player.animation_finished
	
func start_handscan():
	#sound_voice[0] = "sn_cc_scanner_no_hand";
	#sound_voice[1] = "sn_cc_scanner_hand_detected";
	#sound_voice[2] = "sn_cc_scanner_transfer";
	#sound_voice[3] = "sn_cc_scanner_genetic";
	#sound_voice[4] = "sn_cc_scanner_dna";
	B2_Sound.play( "sn_cc_scanner_no_hand" ) # // Hand scanner // Voice #1: no hand //
	await get_tree().create_timer(7.0).timeout
	B2_Sound.play( "sn_cc_scanner_no_hand" ) # // Hand scanner// Voice #1: no hand, repeated //
	await get_tree().create_timer(7.0).timeout
	B2_Sound.play( "sn_cc_scanner_hand_detected" ) # // Hand scanner // Voice #2: Hand detected //
	await get_tree().create_timer(9.0).timeout
	B2_Sound.play( "sn_cc_scanner_transfer" ) # // Hand scanner // Voice #3: Transfer DNA //
	B2_Sound.play( "sn_cc_scanner_flash", 0.0, false, 22 ) # 22 loops
	hand_bg_flip = true
	hand_bg_color.s = 0.5
	await get_tree().create_timer(10.0).timeout
	hand_scanner_device.set_bg_color( Color.TEAL )
	hand_bg_flip = false
	B2_Sound.play( "sn_cc_scanner_genetic" ) # // Hand scanner // Voice #4: Genetic damage warning //
	await get_tree().create_timer(8.0).timeout
	B2_Sound.play( "sn_cc_scanner_dna" ) # // Hand scanner // Voice #4: Scanning DNA //
	beam.show()
	animation_player.play("handscan_scan")
	B2_Sound.play( "sn_cc_scanner_scan", 0.0, false, 24 ) # 22 loops
	await get_tree().create_timer(7.5).timeout
	animation_player.stop()
	beam.hide()
	
	await get_tree().create_timer(1.5).timeout
	end_scan_message.show()
	scan_finished = true
	await mouse_clicked # _process
	end_scan_message.hide()
	
	animation_player.play("hide_handscanner")
	B2_Sound.play( "sn_cc_scanner_disassemble" )
	await animation_player.animation_finished
	
	handscan_finished.emit()

func send_data():
	togtech_cranial.show()
	togtech_cranial.set_mode( false ) # change to data mode
	animation_player.play("send_data")
	await animation_player.animation_finished
	togtech_cranial.hide()
	
	await get_tree().create_timer(0.5).timeout
	cc_transition_scanner.show_transition_scanner()
	await cc_transition_scanner.transition_ended
	
	data_sent.emit()
	
func show_result():
	cc_transition_scanner.show_transition_scanner()
	await cc_transition_scanner.transition_ended
	
	hand_scanner_device.hide()
	togtech_cranial.hide()
	hand_scanner_results.show()
	
	hand_scanner_results.show_result() # we looping!
	await hand_scanner_results.results_shown
	
	cc_transition_scanner.show_transition_scanner()
	await cc_transition_scanner.transition_ended
	
	results_shown.emit()
	
## BG effect
func _process(delta):
	anim_timer -= delta
	if scan_finished:
		if Input.is_action_just_pressed("Action"):
			mouse_clicked.emit()
			
	if anim_timer < 0.0:
		queue_redraw()
		anim_timer = anim_timer_default
		cc_hand_scanner_effect_index += 1
		
	if hand_bg_flip: # // Hand scanner // Voice #3: Transfer DNA //
		hand_bg_color.h += delta * 2.0
		if hand_bg_color.h >= 1.0:
			hand_bg_color.h = 0.0
		hand_scanner_device.set_bg_color( hand_bg_color )
	
func _draw():
	for x : int in get_viewport_rect().size.x / 48 :
		for y : int in get_viewport_rect().size.y / 48 :
			var pos := Vector2( x, y ) * 64
			draw_texture( S_CC_HAND_SCANNER_EFFECT[ cc_hand_scanner_effect_index ], pos - Vector2(8,8)  )
	draw_texture_rect( S_CC_HAND_SCANNER_TECHNO_GRID, get_viewport_rect(), true )
