extends B2_Environ

var cl := [160,200,220,230,255]

func _ready() -> void:
	z_index = 4000

func _physics_process(_delta: float) -> void:
	var c := cl.pick_random() as int
	modulate = Color(c, c, c)
