@tool
extends B2_EnvironInteractive

@onready var ladder: Sprite2D = $ladder

@export var retracted 		:= -46.0
@export var extended 		:= 35.0

@export var ladder_blocker : CollisionShape2D

#Debug
@export_tool_button("ext") var e := _extend_ladder
@export_tool_button("ret") var r := _retract_ladder

func _ready() -> void:
	## Has the ladder been kicked down already? ##
	if B2_Playerdata.Quest("ladderReached") >= 1:
		_extend_ladder()
	else:
		_retract_ladder()
	
func execute_event_user_0():
	_extend_ladder()
	
func _extend_ladder() -> void:
	is_interactive = false
	var move_tween := create_tween()
	move_tween.tween_property( ladder, "position:y", extended, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	if ladder_blocker: ladder_blocker.disabled = true
	
func _retract_ladder() -> void:
	is_interactive = true
	ladder.position.y = retracted
	if ladder_blocker: ladder_blocker.disabled = false
