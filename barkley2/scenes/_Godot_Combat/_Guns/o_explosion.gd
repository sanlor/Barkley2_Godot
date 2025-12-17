extends AnimatedSprite2D
## Explosions are way too complex. I still have no idea how they work.
## Lets try to work out how it actuyally works:
# 	combat_gunwield_shoot line 553 -> create a bullet with some explosion data
#	
# check scr_fx_explosion_createFromType
# check scr_fx_explosion_spawn_at
# check Explode
# check combat_gunwield_shoot line 553
# check o_advBullet event 3
# Motherfucker
# check o_effect_explosion

@onready var explosion_smoke: 	GPUParticles2D 			= $explosion_smoke
@onready var explosion_sfx: 	AudioStreamPlayer2D 	= $explosion_sfx

var explosion_shape 	:= CircleShape2D.new()
var explosion_anim 		:= "s_effect_explo_32"
var explosion_sfx_name	:= "explosion_generic_0"
var explosion_radius 	:= 32.0

var my_gun 				: B2_Weapon

var dmg 				:= 0.0
var explodeDamage 		:= 0.0
var explodeIntensity 	:= 0		# weird ass way to setup an explosion. check scr_fx_explosion_spawn_at -> type

# scr_fx_explosion_createFromType
var init_Radius 		: float = 30;
var att_RadiusGain 		: float = 1;
var init_Pow 			: float = 50;
var init_Height			: float = 0
var att_HeightGain		: float = 0
var att_PowRand 		: float = 8;
var att_PowGain 		: float = -2;
var init_Interval 		: float = 0.1;
var att_IntervalGain 	: float = 0.1;
var att_IntervalRand 	: float = 0.2;
var att_Time 			: float = 18;

func _ready() -> void:
	if my_gun:
		setup_explode_intensity()
		setup_explode_stats()
		setup_sound_effect()
		setup_graphical_effect()
	else:
		push_error("Explosion with no gun...")
		
	explosion_shape.radius = explosion_radius
	if explosion_sfx_name:
		explosion_sfx.stream = B2_Sound.get_sound_stream(explosion_sfx_name)
		explosion_sfx.stream.loop = false
		explosion_sfx.play()
	else:
		push_error("Explosion with no sound effect...")
		
	## play animation
	sprite_frames.set_animation_loop( explosion_anim, false )
	play( explosion_anim, randf_range(0.8,1.2) )
	explosion_smoke.emitting = true
	await get_tree().process_frame

func _on_ready() -> void:
	## Actually apply damage
	damage_actors()

## This is a fucking weird way to set the explosion intensity.
func setup_explode_intensity() -> void:
	dmg = my_gun.weapon_stats.pDamageMin + randf() * my_gun.weapon_stats.pDamageRand # combat_gunwield_shoot line 340
	
	## Set sound
	explodeDamage 		= dmg
	explodeIntensity 	= 0
	
	# 3 = 32, 4 = 40, 5 = 48, 6 = 56, 7 = 64, 7 = 72
	# Flare Guns: min 3 (<=10_PWR)- max 6(>=45_PWR)
	if my_gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
		explodeDamage = clamp(explodeDamage, 10, 35) - 10;
		explodeIntensity = 3 + ceil((explodeDamage / 35) * 3);
		
	# Rockets: min 4(<=10_PWR) - max 8 (>=45P_WR)
	else:
		explodeDamage = clamp(explodeDamage, 10, 35) - 10;
		explodeIntensity = 4 + ceil((explodeDamage / 35) * 4);
		
	assert( explodeIntensity >= 0 and explodeIntensity <= 10, "Explosion type invalid.")

## The spaghetti never ends...
# This applies a bunch of variables that I may never add to the game.
# Also applies screenshake, for no reason!
# check scr_fx_explosion_createFromType line 15
func setup_explode_stats() -> void:
	match int(explodeIntensity):
		0:
			init_Radius = 8;
			att_RadiusGain = 0.5;
			init_Pow = 8 + 2;
			init_Interval = 0.8;
			att_IntervalGain = 0.4;
			att_IntervalRand = 0.4;
			att_Time = 4;
			B2_CManager.camera.add_shake(4, 120, global_position.x, global_position.y, .3);
			
		1:
			init_Radius = 10;
			att_RadiusGain = 0.5;
			init_Pow = 8 + 4;
			init_Interval = 0.6;
			att_IntervalGain = 0.2;
			att_IntervalRand = 0.2;
			att_Time = 6;
			B2_CManager.camera.add_shake(6, 130, global_position.x, global_position.y, .3);
			
		2:
			init_Radius = 12;
			att_RadiusGain = 0.75;
			init_Pow = 12 + 3;
			att_PowGain = -0.4;
			att_PowRand = 8;
			init_Interval = 0.2;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 8;
			B2_CManager.camera.add_shake(8, 140, global_position.x, global_position.y, .5);
		3:
			init_Radius = 16;
			att_RadiusGain = 1;
			init_Pow = 18;
			att_PowRand = 8;
			att_PowGain = -0.6;
			init_Interval = 0.2;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 10;
			B2_CManager.camera.add_shake(9, 150, global_position.x, global_position.y, .5);
			
		4:
			init_Radius = 20;
			att_RadiusGain = 1;
			init_Pow = 24;
			att_PowRand = 8;
			att_PowGain = -1;
			init_Interval = 0.2;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 12;
			B2_CManager.camera.add_shake(10, 160, global_position.x, global_position.y, .5);
			
		5:
			init_Radius = 22;
			att_RadiusGain = 1;
			init_Pow = 28;
			att_PowRand = 8;
			att_PowGain = -1;
			init_Interval = 0.2;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 14;
			B2_CManager.camera.add_shake(16, 170, global_position.x, global_position.y, 1);
			
		6:
			init_Radius = 24;
			att_RadiusGain = 1;
			init_Pow = 28;
			att_PowRand = 8;
			att_PowGain = -1;
			init_Interval = 0.2;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 15;
			B2_CManager.camera.add_shake(16, 180, global_position.x, global_position.y, 1);
		
		7:
			init_Radius = 22;
			att_RadiusGain = 1;
			init_Pow = 32;
			att_PowRand = 8;
			att_PowGain = -1;
			init_Interval = 0.2;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 16;
			B2_CManager.camera.add_shake(16, 190, global_position.x, global_position.y, 1);
			
		8:
			init_Radius = 28;
			att_RadiusGain = 1;
			init_Pow = 44;
			att_PowRand = 8;
			att_PowGain = -2;
			init_Interval = 0.2;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 17;
			B2_CManager.camera.add_shake(28, 200, global_position.x, global_position.y, 1.5);
			
		9:
			init_Radius = 30;
			att_RadiusGain = 1;
			init_Pow = 50;
			att_PowRand = 8;
			att_PowGain = -2;
			init_Interval = 0.1;
			att_IntervalGain = 0.1;
			att_IntervalRand = 0.2;
			att_Time = 18;
			B2_CManager.camera.add_shake(30, 210, global_position.x, global_position.y, 1.5);
			
		10:
			init_Radius = 32;
			att_RadiusGain = -1;
			init_Pow = 16;
			init_Height = 4;
			att_PowRand = 6;
			att_PowGain = -0.6;
			init_Interval = 0.1;
			att_IntervalGain = 0.05;
			att_HeightGain = 0.5;
			att_IntervalRand = 0.2;
			att_Time = 16;
			#move_z = 12;
			B2_CManager.camera.add_shake(32, 220, global_position.x, global_position.y, 1.5);
		_:
			# Invalid type
			breakpoint
	
	init_Interval = 0.5; # *= 2;
	att_IntervalGain = 1; # = 4;
	att_Time /= 2;

func setup_sound_effect() -> void:
	
	explosion_sfx_name = "explosion_generic_" + str(explodeIntensity)
	
func setup_graphical_effect() -> void:
	## Set graphics
	var cur_Pow		:= my_gun.get_bullet_damage() # scr_fx_explosion_createFromType line 21
	
	var 	_pow 	:= cur_Pow + randf_range( 0, att_PowRand );
	if		_pow <= 16:	explosion_anim = "s_effect_explo_16"; explosion_smoke.amount = 8
	elif	_pow <= 24:	explosion_anim = "s_effect_explo_24"; explosion_smoke.amount = 12
	elif	_pow <= 32:	explosion_anim = "s_effect_explo_32"; explosion_smoke.amount = 18
	elif	_pow <= 48:	explosion_anim = "s_effect_explo_48"; explosion_smoke.amount = 24
	else:				explosion_anim = "s_effect_explo_96"; explosion_smoke.amount = 32
	
	## Set explosion size
	explosion_radius = explosion_smoke.amount * 2
	
func damage_actors() -> void:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsShapeQueryParameters2D.new()
	params.collide_with_areas 	= false
	params.collide_with_bodies 	= true
	#params.collision_mask 		= 1 & 2 & 3
	params.shape	 			= explosion_shape
	params.transform			= Transform2D(0, global_position)
	var result : Array[Dictionary] = space_state.intersect_shape(params)
	if result:
		for r : Dictionary in result:
			if r["collider"] is B2_CombatActor:
				var body : B2_CombatActor = r["collider"]
				var _pow := my_gun.get_explosion_damage() + randf_range( 0, att_PowRand )
				body.damage_actor( _pow, global_position.direction_to(body.global_position) * _pow * 100.0 )

func _on_animation_finished() -> void:
	self_modulate.a = 0.0 ## Hide sprite
	
	if explosion_sfx.playing:
		await explosion_sfx.finished
		
	if explosion_smoke.is_emitting():
		await explosion_smoke.finished
		
	queue_free()
