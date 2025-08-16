extends B2_Event_Step_Trigger

# This triggers when you give Jindrich Money

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(_delta: float) -> void:
	# Disable if the Offer is anything but 1 or the Time is before 2 (when Gelasio Appears)
	if B2_Playerdata.Quest("abdulOffer") != 1 or B2_ClockTime.time_gate() >= 2: collision_shape_2d.disabled = true
	else: collision_shape_2d.disabled = false
