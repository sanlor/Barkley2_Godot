extends ColorRect

@onready var hud_dna_strand: TextureRect = $hud_dna_container/hud_dna_strand

# frame is 46 px
# strand is 76 px
var dna_progress := 0.0 :
	set(dna):
		dna_progress = wrapf(dna, 0, 19)
		
func _physics_process(delta: float) -> void:
	dna_progress += 7.5 * delta
	hud_dna_strand.position.x = dna_progress - 30
