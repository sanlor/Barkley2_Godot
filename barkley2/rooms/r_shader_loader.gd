extends Control

## Scene used to load most of the shaders / particles to reduce stutters during gameplay.

const PARTICLES_FOLDER 	:= "res://barkley2/shaders/particles/"
const MATERIAL_FOLDER 	:= "res://barkley2/shaders/material/"
const SHADER_CODE 		:= "res://barkley2/shaders/shader_code/"

const R_TITLE 			:= preload("uid://bpjwpt1mao0nm")

@onready var ball_sprite: Sprite2D 			= $ball_sprite
@onready var loading_lbl: RichTextLabel 	= $MarginContainer/loading_lbl
@onready var cuck_box: Control 				= $cuck_box

var t := 0.0

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	print("%s: Loading shaders... %s" % [name, Time.get_time_string_from_system() ])
	_load_particles()
	_load_materials()
	_load_gdshader()
	print("%s: Finished! %s" % [name, Time.get_time_string_from_system() ])
	await get_tree().create_timer(0.5).timeout
	
	get_tree().change_scene_to_packed( R_TITLE )

func _load_gdshader() -> void:
	var files := DirAccess.get_files_at( SHADER_CODE )
	for file : String in files:
		if file.ends_with(".gdshader"):
			var part := ColorRect.new()
			part.material = ShaderMaterial.new()
			part.material.shader = load( SHADER_CODE + "/" + file )
			cuck_box.add_child( part )
			await get_tree().process_frame

func _load_materials() -> void:
	var files := DirAccess.get_files_at( MATERIAL_FOLDER )
	for file : String in files:
		if file.ends_with(".material") or file.ends_with(".tres"):
			var part := ColorRect.new()
			part.material = load( MATERIAL_FOLDER + "/" + file )
			cuck_box.add_child( part )
			await get_tree().process_frame

func _load_particles() -> void:
	var files := DirAccess.get_files_at( PARTICLES_FOLDER )
	for file : String in files:
		if file.ends_with(".tres"):
			var part := GPUParticles2D.new()
			part.process_material = load( PARTICLES_FOLDER + "/" + file )
			part.emitting = true
			cuck_box.add_child( part )
			await get_tree().process_frame
		
func _physics_process(delta: float) -> void:
	t += 10.0 * delta
	ball_sprite.scale.x = sin( t )
	if ball_sprite.scale.x < 0.0: ball_sprite.modulate = 		Color.DARK_GRAY
	else: ball_sprite.modulate = 								Color.WHITE
 
