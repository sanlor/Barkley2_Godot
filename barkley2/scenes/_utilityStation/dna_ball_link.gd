@tool
extends Node3D

@export var spin := true
@export var enable_link := true
@export var rotate_offset := 0.0

@onready var ball_link_1: CSGSphere3D = $ball_link_1
@onready var ball_link_2: CSGSphere3D = $ball_link_2
@onready var ball_link_3: CSGSphere3D = $ball_link_3


func _ready() -> void:
	rotation = Vector3.ZERO
	rotation.z = rotate_offset * 7.0
	
	if not enable_link:
		ball_link_1.queue_free()
		ball_link_2.queue_free()
		ball_link_3.queue_free()
	
func _process(delta: float) -> void:
	if spin:
		rotation.z += 2.0 * delta
