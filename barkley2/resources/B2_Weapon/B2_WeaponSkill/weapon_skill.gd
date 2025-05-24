extends Resource
class_name B2_WeaponSkill
## Base class for all Weapon's skills

#const O_BULLET 	= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_bullet.tscn")
#const O_CASINGS 	= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_casings.tscn")
#const S_FLASH 		= preload("res://barkley2/scenes/_Godot_Combat/_Guns/muzzle_flash/s_flash.tscn")

signal action_finished

@export_category("General settings")
@export var skill_name 						:= ""   ## Name shown on the combat menu
@export_multiline var skill_description 	:= ""   ## Description shown on the combat menu
@export var skill_ammo_cost 				:= 1	## NOTE Maybe uneeded. Skill ammo cost
@export var skill_action_cost 				:= 100  ## Weapon Action cost ( Values over 100 should overheat the weapon )

@export_category("Skill settings")
@export var bullets_per_shot 				:= 1 	## how many bullets are spawn
@export var ammo_per_shot					:= 1 	## how much ammo is used
@export var wait_per_shot					:= 0.1	## Shotgun spawn all bullets at the same time. Machine gun spawn one at a time
@export var bullet_spread					:= 0.0	## NOT related to accuracy. Shotgun will spread the bullets on a wide arc. a saw-off shotgun should spread a bit more. 0.0 means no spread and TAU is shooting at random. keep at 0.0 to 0.25.
@export var force_bullet_trail				:= false		## Some bullets have no trail. you can force one to have a trail here.
@export var force_bullet_trail_color		:= Color.WHITE	## Bullet trail color. Duh.

@export_category("Cinema settings") ## TODO
@export var pause_combat_during_action		:= true		## Timescale is reduced to 0.1 while the skill action is executed.
@export var vfx_before_delay				: PackedScene ## NOT IMPLEMENTED # Add a specific scene with some kind of visual effect before the dramatic delay
@export var vfx_before_action				: PackedScene ## NOT IMPLEMENTED # Add a specific scene with some kind of visual effect before the action executes
@export var vfx_during_action				: PackedScene ## NOT IMPLEMENTED # Add a specific scene with some kind of visual effect during the action execution
@export var vfx_after_action				: PackedScene ## NOT IMPLEMENTED # Add a specific scene with some kind of visual effect after the action execution
@export var delay_before_action				:= 0.0		## Add a dramatic delay before the shot.
@export var delay_after_action				:= 0.75		## Add a dramatic delay after the shot.
@export var focus_camera_on_user			:= false 	## Enemies and Hoopz should be able to use skills.
@export var focus_camera_speed				:= 1.0		## Speed multiplier
@export var focus_camera_zoom				:= 1.0 		## Higher number == more zoom
## TODO rest of cinematics.

@export_category("Damage Modifiers") ## TODO
@export var att								:= 1.0 ## Higher number = more powerful
@export var spd								:= 1.0 ## Higher number = faster
@export var acc								:= 1.0 ## Lower number = more acturate

@export_category("Attribute Modifiers") ## TODO
@export var bio_damage						:= 1.0 ## Add Bio damage type to this attack
@export var cyber_damage					:= 1.0 ## Add Cyber damage type to this attack
@export var mental_damage					:= 1.0 ## Add Mental damage type to this attack
@export var cosmic_damage					:= 1.0 ## Add Cosmic damage type to this attack
@export var zauber_damage					:= 1.0 ## Add Zauber damage type to this attack

func action( scene_to_place : Node, casing_pos : Vector2, source_pos : Vector2, dir : Vector2, source_actor : B2_CombatActor, weapon : B2_Weapon ) -> void:
	weapon.is_shooting = true
	
	if pause_combat_during_action:
		B2_CManager.combat_manager.pause_combat()
	
	if delay_before_action > 0.0:
		await scene_to_place.get_tree().create_timer( delay_before_action ).timeout
		
	for i in min( bullets_per_shot, weapon.max_ammo ): ## Avoid infinite shooting. https://youtu.be/i7ZGlL8ms_M
		## User was hit, abort shooting.
		if weapon.abort_shooting:
			weapon.abort_shooting = false
			break
			
		var my_spread_offset := bullet_spread * ( float(i) / float(bullets_per_shot) )
		my_spread_offset -= bullet_spread / bullets_per_shot
		
		var my_acc := weapon.get_acc() / 150.0
		my_acc *= acc ## Apply skill modifier.
		var b_dir := dir.rotated( randf_range( -my_acc, my_acc ) + my_spread_offset )
		
		## TODO add skill modifiers
		var bullet = load("uid://ds37xyh4m61b1").instantiate()
		bullet.my_gun = weapon
		bullet.set_direction( b_dir )
		bullet.apply_stat_mods( att, spd )
		bullet.apply_attribute_mods( bio_damage, cyber_damage, mental_damage, cosmic_damage, zauber_damage )
		bullet.setup_bullet_sprite( weapon.get_bullet_sprite(), weapon.get_bullet_color() )
		bullet.source_actor = source_actor
		scene_to_place.add_child( bullet, true )
		bullet.position = source_pos
		
		if wait_per_shot > 0.0: 
			weapon.use_ammo( 1 )
			B2_Sound.play( weapon.get_soundID() )
			weapon.create_flash( scene_to_place, source_pos, b_dir )
			weapon.create_casing( scene_to_place, casing_pos )
			await scene_to_place.get_tree().create_timer( wait_per_shot ).timeout
		else:						## shotgun behaviour.
			weapon.use_ammo( 1 )
			B2_Sound.play( weapon.get_soundID() )
			weapon.create_flash(scene_to_place, source_pos, b_dir)
			weapon.create_casing(scene_to_place, casing_pos)
		
		## Stop firing if you have no ammo.
		if not weapon.has_ammo():
			break
	
	weapon.reset_action( weapon.curr_action - skill_action_cost )
	if not weapon.abort_shooting:
		await scene_to_place.get_tree().create_timer( delay_after_action ).timeout
	weapon.abort_shooting = false
	weapon.is_shooting = false
	
	weapon.finished_combat_action.emit()
	action_finished.emit()
