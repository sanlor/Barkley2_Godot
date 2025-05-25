@tool
extends Control

const MY_SIZE := Vector2(22, 13)

@export var generic_res					:= 0.0
@export var bio_res						:= 0.0 
@export var cyber_res					:= 0.0
@export var mental_res					:= 0.0 
@export var cosmic_res					:= 0.0
@export var zauber_res					:= 0.0
@export_tool_button("Update Graph") var aaaaaaa := _update_graph

func _ready() -> void:
	custom_minimum_size = MY_SIZE

func _update_graph() -> void:
	queue_redraw()
	
func _draw() -> void:
	var x_off := 1
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, (bio_res / 10.0) / MY_SIZE.y ), B2_Gamedata.c_bio, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, (cyber_res / 10.0) / MY_SIZE.y ), B2_Gamedata.c_cyber, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, (mental_res / 10.0) / MY_SIZE.y ), B2_Gamedata.c_mental, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, (cosmic_res / 10.0) / MY_SIZE.y ), B2_Gamedata.c_cosmic, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, (zauber_res / 10.0) / MY_SIZE.y ), B2_Gamedata.c_zauber, 2, false )
	x_off += 4
	draw_line( Vector2( x_off, MY_SIZE.y ), Vector2( x_off, (generic_res / 10.0) / MY_SIZE.y ), Color.WHITE, 2, false )
	
	draw_line( Vector2(0, MY_SIZE.y), MY_SIZE, Color.LIGHT_GRAY, 1, false )
