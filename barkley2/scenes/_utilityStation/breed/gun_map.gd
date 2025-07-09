extends Control

@onready var gun_info: 				Control 	= $"../../.."
@onready var gunmap: 				TextureRect = $gunmap_panel/gunmap_bounds/gunmap
@onready var gun_marker_bottom: 	TextureRect = $gunmap_panel/gunmap_bounds/gunmap/gun_marker_bottom
@onready var gun_marker_top: 		TextureRect = $gunmap_panel/gunmap_bounds/gunmap/gun_marker_top
@onready var gun_marker_occupied: 	TextureRect = $gunmap_panel/gunmap_bounds/gunmap/gun_marker_occupied

@onready var top_gun_texture: 		TextureRect = $top_gun_texture
@onready var bottom_gun_texture: 	TextureRect = $bottom_gun_texture

@onready var slider_peg: ColorRect = $slider/slider_peg

var t : Tween
var t_delay := 0.35

func _ready() -> void:
	#gun_info.ready.connect(populate_gunmap)
	pass
	
func populate_gunmap() -> void:
	top_gun_texture.modulate.a 		= 0.0
	bottom_gun_texture.modulate.a 	= 0.0
	
	gunmap.texture 					= B2_Gunmap.get_gun_map()
	gun_marker_top.position 		= B2_Gunmap.get_gun_map_position( 0, gun_info.selected_gun_1.get_full_name() 	)
	gun_marker_bottom.position 		= B2_Gunmap.get_gun_map_position( 1, gun_info.selected_gun_2.get_full_name() 	)
	gun_marker_occupied.position	= B2_Gunmap.get_gun_map_position( 2, gun_info.bred_gun.get_full_name() 			)
	
	top_gun_texture.texture			= gun_info.selected_gun_1.get_weapon_hud_sprite()
	bottom_gun_texture.texture		= gun_info.selected_gun_2.get_weapon_hud_sprite()
	
	var center = (gun_marker_occupied.position + gun_marker_top.position + gun_marker_bottom.position) / 3
	
	if t:	t.kill()
	t = create_tween()
	## Zoom MAP
	t.tween_property( gunmap, "scale", Vector2.ONE * 1.25, 1.0 )
	
	## Move map arround
	t.tween_property(top_gun_texture, "modulate:a", 1.0, t_delay )				## Influence TOP
	t.parallel().tween_property(slider_peg, "position:y", 0.0, t_delay)			## Influence TOP
	t.parallel().tween_property(gunmap, "position", -gun_marker_bottom.position + Vector2(40,40), t_delay)
	t.tween_interval(0.5)
	
	t.tween_property(bottom_gun_texture, "modulate:a", 1.0, t_delay )			## Influece BOTTOM
	t.parallel().tween_property(slider_peg, "position:y", randf_range(0.0, 50.0),t_delay) ## TODO add a real method to check this.
	t.parallel().tween_property(gunmap, "position", -gun_marker_top.position + Vector2(40,40), t_delay)
	t.tween_interval(t_delay)
	
	t.tween_property(gunmap, "position", -gun_marker_occupied.position + Vector2(40,40), t_delay)
	t.tween_interval(t_delay)
	
	## Draw LINES
	t.tween_property(gunmap, "position", -center + Vector2(40,40), t_delay)
	t.parallel().tween_property(gunmap, "line_ratio", 1.0, t_delay)
	

func zoom_on_bottom() -> void:
	if t:	await t.finished
	t = create_tween()
	t.tween_property(gunmap, "position", -gun_marker_bottom.position + Vector2(40,40), 0.5)
	await t.finished
	
func zoom_on_top() -> void:
	if t:	await t.finished
	t = create_tween()
	t.tween_property(gunmap, "position", -gun_marker_top.position + Vector2(40,40), 0.5)
	await t.finished

func zoom_on_current() -> void:
	if t:	await t.finished
	t = create_tween()
	t.tween_property(gunmap, "position", -gun_marker_occupied.position + Vector2(40,40), 0.5)
	await t.finished

func draw_map_lines() -> void:
	if t:	await t.finished
	var center = (gun_marker_occupied.position + gun_marker_top.position + gun_marker_bottom.position) / 3
	t = create_tween()
	t.tween_property(gunmap, "position", -center + Vector2(40,40), 0.5)
	t.tween_property(gunmap, "line_ratio", 1.0, 0.5)
	await t.finished

func activate_influence_top() -> void:
	if t:	await t.finished
	t = create_tween()
	t.tween_property(top_gun_texture, "modulate:a", 1.0, 0.5 )
	t.tween_property(slider_peg, "position:y", 0.0, 0.5)
	await t.finished
	
func activate_influence_bottom() -> void:
	if t:	await t.finished
	t = create_tween()
	t.tween_property(bottom_gun_texture, "modulate:a", 1.0, 0.5 )
	t.tween_property(slider_peg, "position:y", randf_range(0.0, 50.0), 0.5) ## TODO add a real method to check this.
	await t.finished
