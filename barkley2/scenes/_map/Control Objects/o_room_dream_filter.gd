extends CanvasLayer

@export_category("Hack")
@export var activation_delay := 1.5 ## Delay before activating the blinking animation.
@export var debug_play_blink := true

@onready var filter_logo: Sprite2D = $filter_logo

@onready var eyelid_filler_left: 		Sprite2D = $eyelid_filler_left
@onready var eyelid_filler_right: 		Sprite2D = $eyelid_filler_right
@onready var top_eyelid: 				Sprite2D = $top_eyelid
@onready var botton_eyelid: 			Sprite2D = $botton_eyelid

@onready var dream_filter_1: Sprite2D = $dream_filter
@onready var dream_filter_2: Sprite2D = $dream_filter2
@onready var dream_filter_3: Sprite2D = $dream_filter3
@onready var dream_filter_4: Sprite2D = $dream_filter4


@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Blink ##
var eye_position = 64.0;
var eye_position_goal = 64.0;
var timer_eye_open = 15.0;
var timer_blink = 25.0; 
var blink_blood = 0.1;
var alpha_eye = 0.0;
var alpha_eye_drain = false;
var alpha_intensity 			= 0.0
var override_alpha_intensity 	= 1.0 # applied by the Event User

var layers = 4;

## Dream Filter
var dream_filters := []
var sizeScl 	:= []
var sizeSpd 	:= []
var alphaSpd 	:= []

func _ready() -> void:
	## Dream Filter
	dream_filters = [dream_filter_1, dream_filter_2, dream_filter_3, dream_filter_4]
	
	filter_logo.hide()
	
	for i in layers:
		var df : Sprite2D = dream_filters[i]
		dream_filters[i].show()
		sizeScl.append(randf_range(1.0, 1.5))
		df.scale 		*= sizeScl.back()
		df.modulate 	= Color8(0, 0, 0)
		df.modulate.a 	= 0.1
		sizeSpd.append( randf() * 10 )
		alphaSpd.append( randf() * 10 )
		
	filter_logo.visible = false
	
	## Don't exist after tutorial is done ##
	if B2_Playerdata.Quest( "tutorialProgress", null, 0 ) >= 100:
		queue_free()
		
	#var room : String = get_parent().name
	var room = "" #debug
	print(B2_Playerdata.Quest("tutorialProgress", null, 0))
	if room == "r_fct_factoryOutpost01": alpha_intensity = 0.15;
	elif B2_Playerdata.Quest("tutorialProgress", null, 0) 	== 9: alpha_intensity = 0.3;
	elif B2_Playerdata.Quest("tutorialProgress", null, 0) 	== 8: alpha_intensity = 0.45;
	elif B2_Playerdata.Quest("tutorialProgress", null, 0) 	== 5: alpha_intensity = 0.8;
	else: alpha_intensity = 1;
	
func play_blink():
	if B2_Playerdata.Quest( "zaneState", null, 0 ) == 0:
		if debug_play_blink:
			await get_tree().create_timer(activation_delay).timeout ## HAAAAAAAAAACK. have no idea how the original code handles this delay. 1.5 secs seems perfect.
			animation_player.play("blink")
		else:
			push_error(name, ": Blink is disabled.")
	

func pulse(time : float):
	var frequency := 0.2; ## Frequency in Hz
	return 0.5 * ( 1 + sin(2 * PI * frequency * time) );

func _process(delta: float) -> void:
	override_alpha_intensity = move_toward(override_alpha_intensity, 1.0, delta / 2.0)
	#if Input.is_action_just_pressed("Action"): override_alpha_intensity = 0.0 # Debug
	
	for i in layers:
		if dream_filters[i] == null:
			continue
			
		var df : Sprite2D = dream_filters[i]
		sizeSpd[i] 		+= layers * 0.4 * delta
		alphaSpd[i] 	+= layers * 0.2 * delta
		
		df.scale.x = 1.0 + sizeScl[i] 	* pulse( sizeSpd[i] ) * 0.4
		df.scale.y = 1.0 + sizeScl[i] 	* pulse( sizeSpd[i] ) * 0.4
		
		#df.modulate.a = 0.25 	+ pulse( alphaSpd[i] * 0.5 ) 
		#df.modulate.a *= 3;
		df.modulate.a = alpha_intensity 	+ pulse( alphaSpd[i] * 0.5 ) 
		
		df.modulate.a /= layers;
		df.modulate.a = min(df.modulate.a, override_alpha_intensity)
	
# User Defined code, from GML
func execute_event_user_0():
	# Blink Blood for the eye blood veins
	blink_blood = 1;
	
# User Defined code, from GML
func execute_event_user_1():
	alpha_intensity = 0.65;

# User Defined code, from GML
func execute_event_user_2():
	# Remove the eyelids 
	alpha_eye_drain = true;
	
