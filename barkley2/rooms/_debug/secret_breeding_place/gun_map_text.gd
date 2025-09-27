extends TextureRect

@onready var gun_marker_bottom: 	TextureRect = $gun_marker_bottom
@onready var gun_marker_top: 		TextureRect = $gun_marker_top
@onready var gun_marker_occupied: 	TextureRect = $gun_marker_occupied

@onready var gun_top: 		PanelContainer = $"../gun_top"
@onready var gun_bottom: 	PanelContainer = $"../gun_bottom"
@onready var gun_child: 	PanelContainer = $"../gun_child"

func _ready() -> void:
	texture = B2_Gunmap.get_gun_map()

func _on_h_slider_value_changed(value: float) -> void:
	B2_Gunmap.PERMUTATIONS = int(value)
	_ready()
