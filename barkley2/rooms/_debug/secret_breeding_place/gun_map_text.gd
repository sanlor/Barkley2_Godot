extends TextureRect

@onready var gun_marker_bottom: 	TextureRect = $gun_marker_bottom
@onready var gun_marker_top: 		TextureRect = $gun_marker_top
@onready var gun_marker_occupied: 	TextureRect = $gun_marker_occupied
@onready var line_2d: Line2D = $Line2D


@onready var gun_top: 		PanelContainer = $"../gun_top"
@onready var gun_bottom: 	PanelContainer = $"../gun_bottom"
@onready var gun_child: 	PanelContainer = $"../gun_child"

func _ready() -> void:
	texture = B2_Gunmap.get_gun_map()

func _process(_delta: float) -> void:
	if gun_top.my_gun:
		gun_marker_top.position = gun_top.my_gun.gunmap_pos
	if gun_bottom.my_gun:
		gun_marker_bottom.position = gun_bottom.my_gun.gunmap_pos
	if gun_child.my_gun:
		gun_marker_occupied.position = gun_child.my_gun.gunmap_pos
		line_2d.clear_points()
		line_2d.add_point(gun_marker_top.position)
		line_2d.add_point(gun_marker_bottom.position)

func _on_h_slider_value_changed(value: float) -> void:
	B2_Gunmap.PERMUTATIONS = int(value)
	B2_Gunmap.generate_map()
	_ready()

func _on_v_slider_value_changed(_value: float) -> void:
	gun_child._make_offspring()
