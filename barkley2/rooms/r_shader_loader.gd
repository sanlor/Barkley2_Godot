extends Control

## Scene used to load most of the shaders / particles to reduce stutters during gameplay.

const PARTICLES_FOLDER 	:= "res://barkley2/shaders/particles/"
const MATERIAL_FOLDER 	:= "res://barkley2/shaders/material/"
const SHADER_CODE 		:= "res://barkley2/shaders/shader_code/"

const R_TITLE 			:= preload("uid://bpjwpt1mao0nm")

const CACHE := ResourceLoader.CACHE_MODE_REPLACE_DEEP

@onready var ball_sprite: 			Sprite2D 			= $ball_sprite
@onready var loading_lbl: 			RichTextLabel 	= $MarginContainer/loading_lbl
@onready var loading_detail_lbl: 	Label = $MarginContainer/loading_detail_lbl
@onready var cuck_box: 				Control 				= $cuck_box

const MAX_DOTS 		:= 10
var curr_dots 		:= 0
var t 				:= 0.0

func _ready() -> void:
	loading_detail_lbl.text = ""
	await get_tree().create_timer(0.5).timeout
	loading_detail_lbl.text = Text.pr("Loading particles...")
	await  get_tree().process_frame
	print("%s: Loading particles... %s" % [name, Time.get_time_string_from_system() ])
	_load_particles()
	await get_tree().create_timer(0.1).timeout
	loading_detail_lbl.text = Text.pr("Loading materials...")
	await  get_tree().process_frame
	print("%s: Loading materials... %s" % [name, Time.get_time_string_from_system() ])
	_load_materials()
	await get_tree().create_timer(0.1).timeout
	loading_detail_lbl.text = Text.pr("Loading shaders...")
	await  get_tree().process_frame
	print("%s: Loading shaders... %s" % [name, Time.get_time_string_from_system() ])
	_load_gdshader()
	print("%s: Finished! %s" % [name, Time.get_time_string_from_system() ])
	await get_tree().create_timer(0.5).timeout
	
	get_tree().change_scene_to_packed( R_TITLE )

func _load_gdshader() -> void:
	var files := DirAccess.get_files_at( SHADER_CODE )
	for file : String in files:
		if file.ends_with(".gdshader"):
			var part := ColorRect.new()
			part.size = Vector2(50,50)
			part.material = ShaderMaterial.new()
			part.material.shader = ResourceLoader.load( SHADER_CODE + "/" + file, "", CACHE )
			cuck_box.add_child( part )

func _load_materials() -> void:
	var files := DirAccess.get_files_at( MATERIAL_FOLDER )
	for file : String in files:
		if file.ends_with(".material") or file.ends_with(".tres"):
			var part := ColorRect.new()
			part.size = Vector2(50,50)
			part.material = ResourceLoader.load( MATERIAL_FOLDER + "/" + file, "", CACHE )
			cuck_box.add_child( part )

func _load_particles() -> void:
	var files := DirAccess.get_files_at( PARTICLES_FOLDER )
	for file : String in files:
		if file.ends_with(".tres"):
			var part := GPUParticles2D.new()
			part.texture = preload("uid://ba1yave72rmvn")
			part.process_material = ResourceLoader.load( PARTICLES_FOLDER + "/" + file, "", CACHE )
			part.emitting = true
			cuck_box.add_child( part )
		


func _physics_process(delta: float) -> void:
	t += 10.0 * delta
	ball_sprite.scale.x = sin( t ) #speen
	if ball_sprite.scale.x < 0.0: ball_sprite.modulate = 		Color.DARK_GRAY
	else: ball_sprite.modulate = 								Color.WHITE
 


func _on_timer_timeout() -> void:
	curr_dots = wrapi( curr_dots + 1, 0, MAX_DOTS )
	loading_lbl.text = Text.pr("Now Loading")
	for dot in curr_dots:
		loading_lbl.text += "."
