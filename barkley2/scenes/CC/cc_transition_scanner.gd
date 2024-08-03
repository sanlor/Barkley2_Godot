extends Control

signal transition_ended

var handscanner_img_bank := [
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_0.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_1.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_2.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_3.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_4.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_5.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_6.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_7.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_8.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_9.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_10.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_11.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_12.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_13.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_14.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_15.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_16.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_17.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_18.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_19.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_20.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_21.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_22.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_23.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_24.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_25.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_26.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_27.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_28.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_29.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_30.png",
	"res://barkley2/assets/b2_original/images/cc/s_cc_hand_scanner_noise_31.png",
]
var handscanner_img_array := [] ## Array full of random textures

var can_draw_bg := false

func _ready():
	# preload all textures.
	for x : int in get_viewport_rect().size.x / 16 :
		for y : int in get_viewport_rect().size.y / 16 :
			var tex : Texture2D = load( handscanner_img_bank.pick_random() )
			handscanner_img_array.append( tex )

func show_transition_scanner():
	B2_Sound.play( "sn_cc_scanner_static" )
	can_draw_bg = true
	await get_tree().create_timer(1.5).timeout
	can_draw_bg = false
	transition_ended.emit()
	
func _draw():
	#var start := Time.get_ticks_msec()
	if can_draw_bg:
		
		var index := 0
		handscanner_img_array.shuffle()
		
		for x : int in get_viewport_rect().size.x / 16 :
			for y : int in get_viewport_rect().size.y / 16 :
				draw_texture( handscanner_img_array[index], Vector2( x, y ) * 16 )
				index += 1
				
	# print("transition_scanner: ", Time.get_ticks_msec() - start, " msecs.")
	
func _process(_delta):
	queue_redraw()
