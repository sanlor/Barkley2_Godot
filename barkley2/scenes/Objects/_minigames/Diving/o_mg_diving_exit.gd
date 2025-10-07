@icon("uid://btio5etnmvxbi")
extends Area2D

@onready var detection_area: Area2D = $detection_area

@export var destination := ""
@export var locked		:= false

var is_teleporting := false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if not locked:
		if body.name == "o_mg_diving_player":
			
			if destination:
				B2_RoomXY.warp_to( destination )
				body.is_teleporting = true
				is_teleporting = true
			else:
				push_error("No destination for ", self.name)
