extends B2_Environ

signal hoopz_touched_rupee(value)

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var points_lbl: Label = $points_lbl

var t 	:= 0.0
var t2 	:= 0.0
var is_disabled := false
var value : int

func _ready() -> void:
	points_lbl.hide()
	
	t = randf() * TAU
	t2 = randf() * TAU

func _physics_process(delta: float) -> void:
	if not is_disabled:
		t += 3.0 * delta
		t2 += 3.0 * delta
		offset.y = sin( t ) * 4.0
		point_light_2d.energy = 1.0 + sin(t2) * 0.2
	else:
		offset.y = 0.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is B2_PlayerCombatActor and not is_disabled:
		hoopz_touched_rupee.emit( value )
		disable_rupee()
		
func disable_rupee() -> void:
	points_lbl.text = str( value )
	points_lbl.show()
	is_disabled = true
	if value < 0:
		modulate = Color.DIM_GRAY
	point_light_2d.enabled = false
