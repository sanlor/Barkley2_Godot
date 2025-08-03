extends B2_Camera
class_name B2_Camera_Debug

var old_camera : B2_Camera

func _ready() -> void:
	old_camera = get_viewport().get_camera_2d()
	if old_camera:
		old_camera.enabled = false
	enabled = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_label_pressed(KEY_0):
			if B2_CManager.o_hoopz:
				B2_CManager.o_hoopz.position = position + get_viewport_rect().size / 2.0
			else:
				if get_parent() is B2_ROOMS:
					var room : B2_ROOMS = get_parent()
					room._setup_player_node()
					B2_CManager.o_hoopz.position = position + get_viewport_rect().size / 2.0
				else:
					push_error("Cant create hoopz, not inside a valid room")
		if Input.is_key_label_pressed(KEY_9):
			if B2_CManager.camera:
				B2_CManager.camera.position = position + get_viewport_rect().size / 2.0
			else:
				if get_parent() is B2_ROOMS:
					var room : B2_ROOMS = get_parent()
					if B2_CManager.o_hoopz:
						room._setup_camera(B2_CManager.o_hoopz)
						B2_CManager.camera.position = position + get_viewport_rect().size / 2.0
					else:
						push_error("No valid hoopz to attach a camera")
				else:
					push_error("Cant create hoopz, not inside a valid room")

func _physics_process(delta: float) -> void:
	position += Input.get_vector("Left","Right","Up","Down") * 250.0 * delta

func _draw() -> void:
	draw_circle( get_viewport_rect().size / 2, 8, Color(1,0,0,0.025) )
