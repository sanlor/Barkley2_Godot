@tool
extends NinePatchRect

signal button_pressed

const dentColorThreadLocked := Color.GRAY
const dentColorThreadNormal := Color.WHITE
const dentColorThreadSticky := Color.YELLOW

@onready var thread_title_text: 	Label = $thread_title_text
@onready var thread_poster_text: 	Label = $thread_poster_text
@onready var thread_icon_tex: 		TextureRect = $thread_icon_tex
@onready var thread_favorite: 		TextureButton = $thread_favorite


@export var thread_icon 			:= 0
@export var thread_title			:= "Placeholder"
@export var thread_poster			:= "Placeholder"
@export var is_sticky				:= false
@export var is_locked				:= false
@export var thread_favorite_opt		:= false

@export_tool_button("Update Icon") var _update : Callable = update_button

func _ready() -> void:
	update_button()

func update_button() -> void:
	thread_icon_tex.texture.region.position.x = thread_icon * 29
	thread_title_text.text = thread_title
	thread_poster_text.text = thread_poster
	thread_favorite.button_pressed = thread_favorite_opt
	
	if is_sticky:		self_modulate = dentColorThreadSticky; thread_favorite.visible = false
	elif is_locked:		self_modulate = dentColorThreadLocked; thread_favorite.visible = false
	else:				self_modulate = dentColorThreadNormal; thread_favorite.visible = true


func light_up( enabled : bool ) -> void:
	if enabled:		texture.region.position.x = 30.0
	else:			texture.region.position.x = 0.0

func _on_focus_entered() -> void:
	light_up( true )

func _on_focus_exited() -> void:
	light_up( false )

func _on_mouse_entered() -> void:
	light_up( true )

func _on_mouse_exited() -> void:
	if not has_focus():
		light_up( false )

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventKey:
		if has_focus():
			if Input.is_action_just_pressed("Action"):
				## TODO Add SFX (Like the one used on old Internet explorer when you clicked on a link)
				button_pressed.emit()
