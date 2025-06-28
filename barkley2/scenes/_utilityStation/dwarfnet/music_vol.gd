extends VBoxContainer

@onready var music_vol_slider: HSlider = $music_vol_slider
@export var music_player : AudioStreamPlayer

func _on_music_vol_slider_value_changed(value: float) -> void:
	music_player.volume_linear = value / 100.0

func _on_music_vol_slider_visibility_changed() -> void:
	if not is_node_ready():
		return
	music_vol_slider.value = db_to_linear( music_player.volume_db ) * 100.0
