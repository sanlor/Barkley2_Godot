extends Button

@onready var label: 			Label = $MarginContainer/HBoxContainer/Label
@onready var progress_bar: 		ProgressBar = $MarginContainer/HBoxContainer/ProgressBar
@onready var select_icon: TextureRect = $MarginContainer/HBoxContainer/select_icon

@export var option_name 		:= "Boobs"
@export var option_percent 		:= 35

func _ready() -> void:
	label.text = option_name
	progress_bar.value = option_percent
	progress_bar.hide()

func show_percentage() -> void:
	progress_bar.show()
	
func _on_pressed() -> void:
	select_icon.texture.region.position.x = 10.0
	#print(button_group.get_buttons())
	for b in button_group.get_buttons():
		if b != self:
			b.release_btn()

func release_btn() -> void:
	select_icon.texture.region.position.x = 00.0
	button_pressed = false
