@tool
@icon("uid://3f4lf8kcgany")
extends Area2D
class_name B2_BrainWarp
## Node used for the BrainCity Warp. Very different from the original.

const FN_SMALL = preload("uid://c5asr1c5g1w6h")

@onready var warp_col: CollisionShape2D = $warp_col

@export_category("Warp setup")
@export var warp_destination : B2_BrainWarp
@export var warp_radius := 16.0 :
	set(w):
		warp_radius = w
		_update_radius()

@export_tool_button("Connect Warp") var c : Callable = _connect_warp
@export var exit_point 	:= Vector2( 0, 36 )
@export_tool_button("Flip exit point") var f : Callable = func(): exit_point *= -1; queue_redraw()

@export_category("Warp Animation")
@export var cutscene_script : B2_Script

@export_category("Warp details")
@export var no_destination_text := "No Destination"

func get_exit_point() -> Vector2:
	return global_position + exit_point

func _enter_tree() -> void:
	_setup_warp_cutscene()

func _update_radius() -> void:
	warp_col.shape.radius = warp_radius
	queue_redraw()

## Update graphics and setup warp.
func _connect_warp() -> void:
	if warp_destination:
		warp_destination.warp_destination = self
		warp_destination.queue_redraw()
	queue_redraw()

func _setup_warp_cutscene() -> void:
	if not warp_destination:
		push_error("No warp destination. Fix this.")
		breakpoint
		
	var script := \
	"MOVETO | o_cts_hoopz | %s %s | MOVE_NORMAL
	WAIT   | 0
	PLAYSET | o_cts_hoopz | stairs_enter_down | invisible
	WAIT   | 0
	Misc   | set | o_cts_hoopz | %s
	FRAME  | CAMERA_FAST | %s
	WAIT   | 2            
	PLAYSET | o_cts_hoopz | stairs_exit_down | stand_DOWN
	WAIT   | 0
	MOVETO | o_cts_hoopz | %s %s | MOVE_NORMAL
	WAIT   | 0
	LOOK   | o_cts_hoopz | SOUTH" % [global_position.x, global_position.y, warp_destination.name, warp_destination.name, warp_destination.get_exit_point().x, warp_destination.get_exit_point().y]
	_set_new_cinemascript( script )

func _set_new_cinemascript( script_text : String ) -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := script_text
	scr.original_script = my_script
	cutscene_script = scr

## Debug visualization.
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle( Vector2.ZERO, warp_radius, Color( Color.PINK, 0.125), true )
		
		if warp_destination:
			var dest := warp_destination.global_position - global_position 
			draw_line( Vector2.ZERO, dest, Color( Color.PINK, 0.125), 1.0, false )
			draw_circle( Vector2.ZERO, 8, Color( Color.GREEN, 0.25), true )
			draw_string( FN_SMALL, -Vector2(8,6) / 2.0, "OK", HORIZONTAL_ALIGNMENT_CENTER)
			draw_circle( exit_point, 8, Color.BLUE, false, 1 ) 
		else:
			draw_string( FN_SMALL, -FN_SMALL.global_get_string_size(no_destination_text) / 2.0, no_destination_text, HORIZONTAL_ALIGNMENT_CENTER )


func _on_body_entered(body: Node2D) -> void:
	if body is B2_Player_FreeRoam:
		if warp_destination:
			B2_CManager.play_cutscene( cutscene_script, self )
