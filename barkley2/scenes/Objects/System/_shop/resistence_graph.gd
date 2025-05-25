@tool
extends Control

const MY_SIZE := Vector2(22, 13)

@export var generic_res					:= 100.0
@export var bio_res						:= 100.0 
@export var cyber_res					:= 100.0
@export var mental_res					:= 100.0 
@export var cosmic_res					:= 100.0
@export var zauber_res					:= 100.0
@export_tool_button("Update Graph") var aaaaaaa := _update_graph

func _ready() -> void:
	custom_minimum_size = MY_SIZE
	queue_redraw()

func _update_graph() -> void:
	queue_redraw()
	
func _draw() -> void:
	var x_off := 1
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, 0.0 ), Color( B2_Gamedata.c_bio, 0.125 ), 2, false )
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, MY_SIZE.y * ( bio_res / 200.0 ) ), B2_Gamedata.c_bio, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, 0.0 ), Color( B2_Gamedata.c_cyber, 0.125 ), 2, false )
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, MY_SIZE.y * ( cyber_res / 200.0 ) ), B2_Gamedata.c_cyber, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, 0.0 ), Color( B2_Gamedata.c_mental, 0.125 ), 2, false )
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, MY_SIZE.y * ( mental_res / 200.0 ) ), B2_Gamedata.c_mental, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, 0.0 ), Color( B2_Gamedata.c_cosmic, 0.125 ), 2, false )
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, MY_SIZE.y * ( cosmic_res / 200.0 ) ), B2_Gamedata.c_cosmic, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, 0.0 ), Color( B2_Gamedata.c_zauber, 0.125 ), 2, false )
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, MY_SIZE.y * ( zauber_res / 200.0 ) ), B2_Gamedata.c_zauber, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, 0.0 ), Color( Color.WHITE, 0.125 ), 2, false )
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, MY_SIZE.y * ( generic_res / 200.0 ) ), Color.WHITE, 2, false )
	
	draw_line( Vector2(-2, MY_SIZE.y / 2), Vector2(MY_SIZE.x + 2, MY_SIZE.y / 2), Color( Color.LIGHT_GRAY, 0.5 ), -1, false )
