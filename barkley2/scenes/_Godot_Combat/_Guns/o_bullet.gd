extends Node2D
## Bullet Scene for all bullet type weapons.

## Once again, due to B2´s weirdness, I have to create some weird code.
## Bullet sprites are referenced only as "s_bull" or "s_bull_brass". we have, like, hundredts of sprites like that...
## Initially, I was going to import all sprite animations inside "bullet_spr", but loading 100+ files each time a bullet is created seems dumb.
## Im doing something even dumber!

## TODO Check performance implications of this madness.

@onready var bullet_trail: 	Line2D 				= $bullet_trail
@onready var bullet_spr: 	AnimatedSprite2D 	= $bullet_spr

var dir : Vector2

func set_direction( _dir :Vector2 ) -> void:
	dir = _dir

func setup_bullet_sprite( spr : String, col : Color ) -> void:
	if spr:
		var file_path := "res://barkley2/assets/b2_original/images/merged/" + spr + ".png"
		if FileAccess.file_exists( file_path ):
			var sprite_file = load( file_path )
	modulate = col

func _physics_process(delta: float) -> void:
	position += dir * 5.0 ## TEMP

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
