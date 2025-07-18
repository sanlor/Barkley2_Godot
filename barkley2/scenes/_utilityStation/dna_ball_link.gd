@tool
extends Node3D

const DNA_BALL_LINK = preload("res://barkley2/resources/utility_station/dna_ball_link.tres")

@export var spin 			:= true
@export var enable_link 	:= true
@export var rotate_offset 	:= 0.0

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
		
	change_color( Color.PINK )
	
func change_color( color : Color ) -> void:
	var mat := DNA_BALL_LINK.duplicate()
	mat.vertex_color_use_as_albedo = true
	mat.albedo_color = color
	for c : CSGSphere3D in get_children():
		c.material = mat
	
func _physics_process(delta: float) -> void:
	if spin and visible:
		rotation.z += 3.0 * delta
