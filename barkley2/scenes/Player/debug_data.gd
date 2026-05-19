extends Control

@onready var label: Label = $Label
@export var ai : B2_AI

func _ready() -> void:
	if not OS.is_debug_build():
		print( "Removing debug label from %s. remember to manually remove it." % get_parent().name )
		queue_free()
	z_index = 1000

func _physics_process(_delta: float) -> void:
	if get_parent() is B2_EnemyCombatActor:
		if get_parent().actor_ai:
			if not ai: ai = get_parent().actor_ai
			if ai.curr_STATE:
				label.text = "AI State: %s\n" % ai.curr_STATE.name
			else:
				label.text = ""
			
			label.text += "Inputs:\n"
			label.text += "WX: %s, WY: %s\n" % [ str( snapped(get_parent().curr_input.x,0.01) ).pad_decimals(2), str( snapped(get_parent().curr_input.y,0.01) ).pad_decimals(2) ]
			label.text += "AX: %s, AY: %s" % [ str( snapped(get_parent().curr_aim.x,0.01) ).pad_decimals(2), str( snapped(get_parent().curr_aim.y,0.01) ).pad_decimals(2) ]
