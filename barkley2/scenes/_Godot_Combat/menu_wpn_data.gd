extends HBoxContainer

@onready var menu_wpn_spr: TextureRect = $menu_wpn_spr
@onready var menu_wpn_name: Label = $menu_wpn_name
@onready var menu_wpn_action: ProgressBar = $menu_wpn_action

var combat_wpn 			#: WpnBase
var check_selection 	:= false
var alpha				:= 1.0

@export var selected_color := Color.CADET_BLUE

func update() -> void:
	if combat_wpn:
		menu_wpn_name.text = combat_wpn.weapon_name
		menu_wpn_action.max_value = combat_wpn.max_action
		menu_wpn_action.value = combat_wpn.curr_action
		## TODO use menu_wpn_spr to reflect damage type (ranged, melee)
	else:
		push_error("combat_wpn not set.")
	
func _process(_delta: float) -> void:
	if check_selection and combat_wpn:
		if combat_wpn.is_selected:
			modulate = Color( selected_color, alpha )
		else:
			modulate = Color( Color.WHITE, alpha )
