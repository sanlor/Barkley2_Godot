extends Control

## Scene used to load most of the shaders / particles to reduce stutters during gameplay.

const SHADER_FOLDER := "res://barkley2/shaders/particles/"
const R_TITLE 		:= preload("uid://bpjwpt1mao0nm")

@onready var ball_sprite: Sprite2D 			= $ball_sprite
@onready var loading_lbl: RichTextLabel 	= $MarginContainer/loading_lbl
@onready var cuck_box: Control 				= $cuck_box

var t := 0.0

func _ready() -> void:
	print("%s: Loading shaders... %s" % [name, Time.get_time_string_from_system() ])
	await get_tree().process_frame
	load_all_shaders()
	await get_tree().process_frame
	print("%s: Finished! %s" % [name, Time.get_time_string_from_system() ])
	get_tree().change_scene_to_packed( R_TITLE )

func load_all_shaders() -> void:
	var files := DirAccess.get_files_at( SHADER_FOLDER )
	for file : String in files:
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		
		var part := GPUParticles2D.new()
		part.process_material = load( SHADER_FOLDER + "/" + file )
		part.emitting = true
		cuck_box.add_child( part )
		

func _physics_process(delta: float) -> void:
	t += 10.0 * delta
	ball_sprite.scale.x = sin( t )
	if ball_sprite.scale.x < 0.0: ball_sprite.modulate = 		Color.DARK_GRAY
	else: ball_sprite.modulate = 								Color.WHITE
 
