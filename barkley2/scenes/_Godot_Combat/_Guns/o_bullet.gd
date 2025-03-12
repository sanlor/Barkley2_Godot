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

## Gamedev is my passion...
# here is the thing; this game uses too many bullet types. Making a bullet with a fuck ton of animations seems wasteful.
# my idea is this: lets make an animation on the fly! shouldnt impact the performance.
## NOTE forget that, I just added all animations using a convetion script. 11/03/25
func setup_bullet_sprite( spr : String, col : Color ) -> void:
	if spr:
		if bullet_spr.sprite_frames.has_animation( spr ):
			bullet_spr.animation = spr
			bullet_spr.look_at( position + dir )
		else:
			push_warning("No animation called %s." % spr)
		
	modulate = col

func _physics_process(delta: float) -> void:
	position += dir * 5.0 ## TEMP

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
