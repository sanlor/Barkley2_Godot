extends CanvasLayer

@onready var s_effect_alarm_light: Sprite2D = $s_effect_alarmLight
@onready var red_color: ColorRect = $red_color

var time := 0.0
var is_active := false

func _ready() -> void:
	s_effect_alarm_light.hide()
	red_color.show()
	red_color.modulate.a = 0.0
	
	if B2_Playerdata.Quest("tutorialProgress") == 9:
		activate()
	
func activate():
	is_active = true
	
func deactivate():
	is_active = false
	red_color.modulate.a = 0.0
	
func _physics_process(delta: float) -> void:
	if is_active:
		time += 1.5 * delta
		var alpha := ( sin(time) + 1.0 ) / 4.0
		alpha -= 0.3
		red_color.modulate.a = alpha
