@tool
extends Control
## 30/09/25 No idea why I named this like this.
# this is actually the influence / bias a gun can have over another.
## TODO make this work.

const MIN_POS := 0.0
const MAX_POS := 120.0

@onready var the_bar_tm: ColorRect = $main_panel/i_dont_fucking_know/the_bar_tm

@export_tool_button("update bar position") var b : Callable = _update_pos

@export var top_influence 		:= 0.0
@export var bottom_influence 	:= 0.0

func update_top_influence( _seed : String ) -> void:
	var r := RandomNumberGenerator.new()
	r.seed = hash( _seed )
	top_influence = r.randf()
	_update_pos()
	
func update_bottom_influence( _seed : String ) -> void:
	var r := RandomNumberGenerator.new()
	r.seed = hash( _seed )
	bottom_influence = r.randf()
	_update_pos()

func _update_pos() -> void:
	var influence : float = (-top_influence * MAX_POS) + ( bottom_influence * MAX_POS )
	the_bar_tm.position.y = clampf( influence + MAX_POS/2, MIN_POS, MAX_POS )

func _on_visibility_changed() -> void:
	if is_node_ready():
		_update_pos()
