extends Control

const BLIP = preload("res://barkley2/resources/B2_Weapon/blip.tres")

@onready var gb_size: Label = $MarginContainer/VBoxContainer/gb_size

func update() -> void:
	queue_redraw()

func _draw() -> void:
	var x := 0
	var y := 1
	for wpn : B2_Weapon in B2_Gun.get_gunbag():
		var b := BLIP
		b.region.position.x = 8 * wpn.weapon_type
		draw_texture( b, Vector2(x * 9, y * 9) + Vector2(3,5) )
		x += 1
		if x > 6:
			x = 0
			y += 1

	var b2 := BLIP
	b2.region.position.x = 0
	draw_texture( b2, Vector2(x * 9, y * 9) + Vector2(3,5), Color.RED )
	
	gb_size.text = "%s / %s" % [ str( B2_Gun.get_gunbag().size() ).pad_zeros(2), str( B2_Gun.GUNBAG_SIZE ).pad_zeros(2) ]
