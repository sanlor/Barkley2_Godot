extends Control

## Scene used to load most of the shaders / particles to reduce stutters during gameplay.

const PARTICLES_FOLDER 	:= "res://barkley2/shaders/particles/"
const MATERIAL_FOLDER 	:= "res://barkley2/shaders/material/"
const SHADER_CODE 		:= "res://barkley2/shaders/shader_code/"

const R_TITLE 			:= preload("uid://bpjwpt1mao0nm")

const CACHE := ResourceLoader.CACHE_MODE_REUSE
##	● CACHE_MODE_IGNORE = 0
#		Neither the main resource (the one requested to be loaded) nor any of its subresources are retrieved from cache nor stored into it. 
#		Dependencies (external resources) are loaded with CACHE_MODE_REUSE.
##	● CACHE_MODE_REUSE = 1
#		The main resource (the one requested to be loaded), its subresources, and its dependencies (external resources) are retrieved from cache if present, instead of loaded.
#		Those not cached are loaded and then stored into the cache. The same rules are propagated recursively down the tree of dependencies (external resources).
##	● CACHE_MODE_REPLACE = 2
#		Like CACHE_MODE_REUSE, but the cache is checked for the main resource (the one requested to be loaded) as well as for each of its subresources. 
#		Those already in the cache, as long as the loaded and cached types match, have their data refreshed from storage into the already existing instances. 
#		Otherwise, they are recreated as completely new objects.
##	● CACHE_MODE_IGNORE_DEEP = 3
#		Like CACHE_MODE_IGNORE, but propagated recursively down the tree of dependencies (external resources).
##	● CACHE_MODE_REPLACE_DEEP = 4
#		Like CACHE_MODE_REPLACE, but propagated recursively down the tree of dependencies (external resources).

@onready var ball_sprite: 			Sprite2D 				= $ball_sprite
@onready var margin_container: 		MarginContainer 		= $MarginContainer
@onready var loading_lbl: 			RichTextLabel 			= $MarginContainer/loading_lbl
@onready var loading_detail_lbl: 	Label 					= $MarginContainer/loading_detail_lbl
@onready var cuck_box: 				Control 				= $cuck_box

const MAX_DOTS 		:= 10
var curr_dots 		:= 0
var t 				:= 0.0

func _ready() -> void:
	## Reset Label
	loading_detail_lbl.text = ""
	
	## Load Particles
	await get_tree().create_timer(0.25).timeout
	loading_detail_lbl.text = Text.pr("Loading particles...")
	print("%s: Loading particles... %s" % [name, Time.get_time_string_from_system() ])
	await get_tree().process_frame
	_load_particles()
	
	## Load Materials
	await get_tree().create_timer(0.25).timeout
	loading_detail_lbl.text = Text.pr("Loading materials...")
	print("%s: Loading materials... %s" % [name, Time.get_time_string_from_system() ])
	await get_tree().process_frame
	_load_materials()
	
	## Load Shaders
	await get_tree().create_timer(0.25).timeout
	loading_detail_lbl.text = Text.pr("Loading shaders...")
	print("%s: Loading shaders... %s" % [name, Time.get_time_string_from_system() ])
	await get_tree().process_frame
	_load_gdshader()
	
	## Aaaaand...
	print("%s: Finished! %s" % [name, Time.get_time_string_from_system() ])
	
	## Finish loading.
	var tween := create_tween()
	tween.tween_property( ball_sprite, 		"self_modulate", Color.TRANSPARENT, 0.25 )
	tween.tween_property( margin_container, 	"self_modulate", Color.TRANSPARENT, 0.25 )
	tween.tween_interval( 0.5 )
	tween.tween_callback( get_tree().change_scene_to_packed.bind( R_TITLE ) )

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
