extends Node2D
## Controls the crowd during the Gov. Speech.
## Tried to use the original code, but it didnt work. We are using Tweens now.

const O_EFFECT_ZHANG_CONFETTI_BLAST = preload("uid://cicnxt8ps0n5y")

var room : B2_ROOMS

var o_xorg01 : 			B2_InteractiveActor
var o_gulpster01 : 		B2_InteractiveActor
var o_flipboy01 : 		B2_InteractiveActor
var o_elrond01 : 		B2_InteractiveActor
var o_hapsburg01 : 		B2_InteractiveActor
var o_gubbe01 : 		B2_InteractiveActor
var o_urdok01 : 		B2_InteractiveActor
#var o_govWatcher08 : 	B2_InteractiveActor
#var o_govWatcher09 : 	B2_InteractiveActor
var o_ilyich01 : 		B2_InteractiveActor
var o_kim01 : 			B2_InteractiveActor
var o_lafferty01 : 		B2_InteractiveActor
var o_vikingstad01 : 	B2_InteractiveActor
var o_lucretia01 : 		B2_InteractiveActor

## Arrays
var obj 			:= []
var objTyp 			:= []
var objAmt			:= 12
var objShkX 		:= [];
var objShkY 		:= [];
var objShkSpdX 		:= [];
var objShkSpdY 		:= [];
var objShkFrcX 		:= []; #Friction
var objShkFrcY 		:= [];
var objShkDisX 		:= [];
var objShkDisY 		:= [];
var objShkDirX 		:= [];
var objShkDirY 		:= [];

var arg				:= "bad"

## Godot stuff
var dwarfes 	:= []
var duergars 	:= []

func _ready() -> void:
	if get_parent() is B2_ROOMS:
		room = get_parent()
		
		o_xorg01 		= room.get_node("o_xorg01")
		o_gulpster01 	= room.get_node("o_gulpster01")
		o_flipboy01 	= room.get_node("o_flipboy01")
		o_elrond01 		= room.get_node("o_elrond01")
		o_hapsburg01 	= room.get_node("o_hapsburg01")
		o_gubbe01 		= room.get_node("o_gubbe01")
		o_urdok01 		= room.get_node("o_urdok01")
		o_ilyich01 		= room.get_node("o_ilyich01")
		o_kim01 		= room.get_node("o_kim01")
		o_lafferty01 	= room.get_node("o_lafferty01")
		o_vikingstad01 	= room.get_node("o_vikingstad01")
		o_lucretia01 	= room.get_node("o_lucretia01")
		
		dwarfes 	= [o_xorg01,o_gulpster01,o_flipboy01,o_elrond01,o_hapsburg01,o_gubbe01,o_urdok01,o_ilyich01]
		duergars 	= [o_kim01,o_lafferty01,o_vikingstad01,o_lucretia01]
		
		obj.resize(			objAmt)
		objTyp.resize(		objAmt)
		objShkX.resize(		objAmt)
		objShkY.resize(		objAmt)
		objShkSpdX.resize(	objAmt)
		objShkSpdY.resize(	objAmt)
		objShkFrcX.resize(	objAmt)
		objShkFrcY.resize(	objAmt)
		objShkDisX.resize(	objAmt)
		objShkDisY.resize(	objAmt)
		objShkDirX.resize(	objAmt)
		objShkDirY.resize(	objAmt)
		
		var i := 0
		obj[i] = o_xorg01; objTyp[i] = "good"; i += 1;
		obj[i] = o_gulpster01; objTyp[i] = "good"; i += 1;
		obj[i] = o_flipboy01; objTyp[i] = "good"; i += 1;
		obj[i] = o_elrond01; objTyp[i] = "good"; i += 1;
		obj[i] = o_hapsburg01; objTyp[i] = "good"; i += 1;
		obj[i] = o_gubbe01; objTyp[i] = "good"; i += 1;
		obj[i] = o_urdok01; objTyp[i] = "good"; i += 1;
		obj[i] = o_ilyich01; objTyp[i] = "good"; i += 1;

		obj[i] = o_kim01; objTyp[i] = "bad"; i += 1;
		obj[i] = o_lafferty01; objTyp[i] = "bad"; i += 1;
		obj[i] = o_vikingstad01; objTyp[i] = "bad"; i += 1;
		obj[i] = o_lucretia01; objTyp[i] = "bad"; i += 1;
			
		for ii in objAmt:
			objShkX[ii] = 0;
			objShkY[ii] = 0;
			objShkSpdX[ii] = 0;
			objShkSpdY[ii] = 0;
			objShkFrcX[ii] = 0; # Friction
			objShkFrcY[ii] = 0;
			objShkDisX[ii] = 0;
			objShkDisY[ii] = 0;
			objShkDirX[ii] = 0;
			objShkDirY[ii] = 0;
			
		arg = "good";
	else:
		## Where am I???
		breakpoint
		
# Good jump
func execute_event_user_0():
	arg = "good";
	B2_Sound.play("sn_dwarf_agree01")
	#execute_event_user_10()
	for i in dwarfes:
		var tween := create_tween()
		for ii in 5:
			_jump_around( i, tween )

# Good shake
func execute_event_user_1():
	arg = "good";
	B2_Sound.play("sn_dwarf_angry01")
	#execute_event_user_11()
	for i in dwarfes:
		var tween := create_tween()
		for ii in 3:
			_shake_around( i, tween )

# Bad jump
func execute_event_user_2():
	arg = "bad";
	B2_Sound.play("sn_duergar_agree01")
	#execute_event_user_10()
	for i in duergars:
		var tween := create_tween()
		for ii in 5:
			_jump_around( i, tween )

# Bad shake
func execute_event_user_3():
	arg = "bad";
	B2_Sound.play("sn_duergar_angry01")
	#execute_event_user_11()
	for i in duergars:
		var tween := create_tween()
		for ii in 3:
			_shake_around( i, tween )

# Confetti time
func execute_event_user_4():
	for i in duergars:
		var conf : GPUParticles2D = O_EFFECT_ZHANG_CONFETTI_BLAST.instantiate()
		conf.emit_delay( randf() )
		i.add_child( conf )
	
	for i in dwarfes:
		var conf : GPUParticles2D = O_EFFECT_ZHANG_CONFETTI_BLAST.instantiate()
		conf.emit_delay( randf() )
		i.add_child( conf )
	
## AI code by copilot.
func _jump_around( actor : B2_InteractiveActor, tween : Tween ) -> void:
	assert(actor, "Actor is null.")
	var jump_height 	:= randf_range(5.0,15.0)
	var jump_time 		:= randf_range(0.25,0.65)
	var start_y 		:= actor.ActorAnim.position.y

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(actor.ActorAnim, "position:y", start_y - jump_height, jump_time / 2)

	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(actor.ActorAnim, "position:y", start_y, jump_time / 2)

## AI code by copilot.
func _shake_around( actor : B2_InteractiveActor, tween : Tween, amplitude := randf_range(2.5,5.0), duration := randf_range(0.5,1.0), vibrations := randi_range(1,3) ) -> void:
	var start_pos := actor.ActorAnim.position
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	for i in range(vibrations):
		var offset = amplitude if i % 2 == 0 else -amplitude
		tween.tween_property(actor.ActorAnim,"position:x",start_pos.x + offset, duration / vibrations)

	tween.tween_property(actor.ActorAnim,"position:x",start_pos.x,duration / vibrations)

#region Legacy code

## Jump
#func execute_event_user_10():
	#for i in objAmt:
		#if objTyp[i] == arg:
			#objShkDisY[i] = 10 + randi_range(0,4)
			#objShkFrcY[i] = objShkDisY[i] / ( 5 + floor( randi_range(0,4) ) )
			#objShkDirY[i] = 0
			#objShkSpdY[i] = ( 450 + randi_range(0,180) ) * [1, -1].pick_random()
			#
			##Slight shake
			#if randf() < 0.5:
				##objShkDisX[i] = 1;
				##objShkFrcX[i] = objShkDisX[i] / (10 + floor(random(6)));
				##objShkDirX[i] = 0;
				##objShkSpdX[i] = (360 + random(90)) * choose(1, -1);
				#pass
## shake
#func execute_event_user_11():
	#for i in objAmt:
		#if objTyp[i] == arg:
			#objShkDisX[i] = 1 + randi_range(0,1);
			#objShkFrcX[i] = objShkDisX[i] / ( 18 + floor( randi_range(0,9) ) )
			#objShkDirX[i] = 0;
			#objShkSpdX[i] = ( 900 +  randi_range(0,90) ) * [1, -1].pick_random()
			
#func _physics_process(delta: float) -> void:
	#for i in objAmt:
		#if objShkDisY[i] > 0:
			##obj[i].y = obj[i].ystart + min(0, lengthdir_y(objShkDisY[i], objShkDirY[i]));
			#obj[i].ActorAnim.position.y = minf( 0, objShkDisY[i] ) #lengthdir_y(objShkDisY[i], objShkDirY[i]));
			##obj[i].shadow_sprite_offset_y = abs(min(0, lengthdir_y(objShkDisY[i], objShkDirY[i])));
			#objShkDirY[i] += objShkSpdY[i] * delta;
			#if objShkDirY[i] > 360 || objShkDirY[i] < -360:
				#if objShkDirY[i] > 360: objShkDirY[i] -= 360;
				#else: objShkDirY[i] += 360;
				#objShkDisY[i] -= objShkFrcY[i];
				#objShkFrcY[i] *= 2;
		#else: obj[i].ActorAnim.position.y = 0 #obj[i].ystart;
		#
		#if objShkDisX[i] > 0:
			##obj[i].x = obj[i].xstart + lengthdir_y(objShkDisX[i], objShkDirX[i]);
			#obj[i].ActorAnim.position.y = minf( 0, objShkDisX[i] ) #lengthdir_y(objShkDisY[i], objShkDirY[i]));
			#objShkDirX[i] += objShkSpdX[i] * delta;
			#if objShkDirX[i] > 360 || objShkDirX[i] < -360:
				#if objShkDirX[i] > 360: objShkDirX[i] -= 360;
				#else: objShkDirX[i] += 360;
				#objShkDisX[i] -= objShkFrcX[i];
				#objShkFrcX[i] *= 2;
		#else: obj[i].ActorAnim.position.x = 0 #obj[i].xstart;
#endregion
