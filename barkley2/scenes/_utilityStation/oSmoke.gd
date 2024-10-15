extends GPUParticles2D

# Check oPuff, oSmoke, oSmokeMass
# Im dumb. I cant replicate the original smoke effect

func _ready() -> void:
	emitting = true
	await finished
	queue_free()
