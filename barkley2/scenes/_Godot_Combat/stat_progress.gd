@tool
extends Control

@onready var bg_frame: TextureRect = $bg_frame
@onready var stat_bar: TextureRect = $stat_bar
@onready var stat_top_frame: NinePatchRect = $stat_top_frame

const SIZE_X := 32.0

var max_value 	:= 100.0
var value 		:= 70.0

@export var my_color	:= Color.CRIMSON
@export var bg_darken	:= 0.5

func _ready() -> void:
	bg_frame.modulate = my_color.darkened( bg_darken )
	stat_bar.modulate = my_color

func update_bar() -> void:
	if max_value == 0:
		stat_bar.size.x = 0
		return
		
	stat_top_frame.size.x 	= SIZE_X
	bg_frame.size.x 		= SIZE_X - 2.0
	stat_bar.size.x 		= (SIZE_X - 2.0) * value / max_value
	
