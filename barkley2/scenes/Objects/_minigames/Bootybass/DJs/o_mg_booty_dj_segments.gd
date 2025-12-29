@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
extends Node
## This node controls the DJ music 
## INFO https://www.youtube.com/watch?v=-y39SGVHBnA

# // DJ SEGMENTS // 
#	0 = anime bulldog, 
#	1 = the other guy 
# // Change the dj variable when you create this instance accordingly //

## The original code has a bunch of math to make the camera spin around.
@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

signal finished ## Emited after the event finishes. This is CRITICAL for the proper callback to the cinema script

var dj 				:= 0;

# Start timer #
var timer 			:= 30; #180
var timer_segment 	:= 100; #2300 // 385
var timer_return 	:= 0;   # 0 default
var timer_camera 	:= 25;

var camera_is_spining := false

@export var o_mg_booty_surface : Node

func _ready() -> void:
	# This node expects to find a node called "o_mg_booty_surface" as its sibling.
	o_mg_booty_surface = get_parent().find_child("o_mg_booty_surface")
	
	assert( is_instance_valid(o_mg_booty_surface), "Node 'o_mg_booty_surface' not found." )
	
	# Lights off #
	o_mg_booty_surface.disable_light();
	
	B2_Music.play("mus_blankTEMP", 0.0)
	#instance_create(0, 0, o_mg_booty_camera);
	#push_warning(">>>> %s <<<<: still INDEV." % name)
	#spin_camera()

func play_music() -> void:
	var stream := AudioStreamPlayer.new()
	stream.bus = "Music"
	stream.finished.connect( _music_finished )
	if dj == 0:		stream.stream = B2_Music.get_music_stream("mus_tnn_animebulldog")
	elif dj == 1:	stream.stream = B2_Music.get_music_stream("mus_tnn_bootyclapper")
	else:			breakpoint
	stream.stream.loop = false
	add_child( stream, true ) 
	stream.play()
	
func enable_dj_lights() -> void:
	if dj == 1:	o_mg_booty_surface.bootyslayer_lights()
	if dj == 0:	o_mg_booty_surface.animebulldog_lights()
	
func _music_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	camera_is_spining = false
	o_mg_booty_surface.enable_light() ## Re-enable normal lightsx
	finished.emit()
	queue_free() # bubye
	
func spin_camera() -> void: # replaces 'o_mg_booty_camera'.
	B2_CManager.camera.follow_player( path_follow_2d )
	camera_is_spining = true

var speen_spid := 0.0 ## allow for a smooth acceleration.
func _physics_process(delta: float) -> void:
	if camera_is_spining:
		speen_spid = lerp(speen_spid, delta * 0.075, 0.005)
		path_follow_2d.progress_ratio += speen_spid
