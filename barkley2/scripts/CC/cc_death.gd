extends Control

signal stopped_smoke

@onready var death_screen = $death_screen

@onready var name_label = $death_screen/name_label
@onready var date_birth_label = $death_screen/date_birth_label
@onready var date_death_label = $death_screen/date_death_label

@onready var particle_1 = $Particle_1

var weird_offset := Vector2(16,0)

func _ready():
	name_label.modulate = Color.RED
	name_label.text = Text.pr( B2_Playerdata.character_name )
	name_label.position = Vector2(192, 104) - weird_offset
	
	date_birth_label.modulate = Color.TEAL
	date_birth_label.text = str( B2_Playerdata.character_zodiac_day, ".", B2_Playerdata.character_zodiac_month, ".\n", B2_Playerdata.character_zodiac_year )
	date_birth_label.position = Vector2(163, 133)- weird_offset
	
	date_death_label.modulate = Color.TEAL
	date_death_label.text = str( B2_Playerdata.character_zodiac_day, ".", B2_Playerdata.character_zodiac_month, ".\n", B2_Playerdata.character_zodiac_year )
	date_death_label.position = Vector2(216, 133) - weird_offset
	
	modulate.a = 0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	await get_tree().create_timer(2).timeout
	particle_1.emitting = false
	await get_tree().create_timer(4).timeout
	stopped_smoke.emit()
	
func _process(delta):
	
	pass
	#// Setup stuff //
	#interval = 0.1;
#
	#system = part_system_create();
	#part_system_depth(system, -100);
#
	#emitter = part_emitter_create(system);
	#part_emitter_region(system, emitter, 190, 194, 118, 122, ps_shape_rectangle, ps_distr_linear);
#
	#particle = part_type_create();
	#part_type_alpha2(particle, 0.2, 0.4);
	#part_type_color2(particle, make_color_rgb(250, 0, 0), make_color_rgb(155, 0, 0));
	#part_type_life(particle, 100, 150);
	#part_type_speed(particle, 0.2, 0.01, 0.1, 0);
	#part_type_direction(particle, 0, 360, 1, 0);
	#part_type_size(particle, 0.1, 0.25, 0.02, 0);
	#part_type_shape(particle, pt_shape_explosion);
#
	#particle2 = part_type_create();
	#part_type_alpha2(particle2, 0.2, 0.4);
	#part_type_color2(particle2, make_color_rgb(60, 0, 50), make_color_rgb(60, 20, 50));
	#part_type_life(particle2, 100, 150);
	#part_type_speed(particle, 0.2, 0.01, 0.1, 0);
	#part_type_direction(particle, 0, 360, 1, 0);
	#part_type_size(particle, 0.1, 0.25, 0.02, 0);
	#part_type_shape(particle, pt_shape_explosion);
	
