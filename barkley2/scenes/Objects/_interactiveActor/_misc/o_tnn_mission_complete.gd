@tool
extends Control

# check o_tnn_mission_complete
## INCOMPLETE, DOES NOTHING
# 30/12/25 does something now.

signal finished

@onready var center: RichTextLabel = $center
@onready var h_label: RichTextLabel = $h_label
@onready var v_label: RichTextLabel = $v_label

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var txt 			:= "Mission Complete"
var parsed_text 	:= ""
var funky_color 	:= Color.from_hsv(1.0,1.0,1.0)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	# Add a space between all letters
	for letter : String in txt:
		parsed_text += letter + " "
		
	center.text 	= Text.pr( parsed_text )
	
	h_label.text 	= "[wave amp=100.0 freq=20.0 connected=1]" + Text.pr( parsed_text ) + "[/wave]"
	v_label.text 	= "[tornado radius=50.0 freq=20.0 connected=1]" + Text.pr( parsed_text ).replace(" ", "\n\n") + "[/tornado]"
	
	animation_player.play("za_completion_of_the_mission")

func _physics_process(_delta: float) -> void:
	if is_node_ready():
		center.self_modulate 	= funky_color
		h_label.self_modulate 	= funky_color
		v_label.self_modulate 	= funky_color
		
		funky_color.h = wrapf( funky_color.h + 0.01, 0.0, 1.0 )
		#funky_color.r8 = wrapi( funky_color.r8 + 5, 0, 255 )
		#funky_color.g8 = wrapi( funky_color.g8 + 10, 0, 255 )
		#funky_color.b8 = wrapi( funky_color.b8 + 15, 0, 255 )

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	finished.emit()
	queue_free()
