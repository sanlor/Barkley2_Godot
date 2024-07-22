@tool
extends Node2D

@onready var cc_gumball = $".."

var back_gumball_amount := 80
var front_gumball_amount := 120

func _ready():
	await cc_gumball.ready
	
	## poor imitation of the o_cc_gumball event0.
	for i in 40:
		var _dir := randf() * TAU
		var _scale := 0.25 + randf_range(0, 0.1)
		var _my_len := randf() * 25.0
		var _black := 0.8
		make_gunball(randi_range(0,12), _dir, _my_len, Vector2( _scale, _scale ), _black )
	
	for i in 80:
		var _dir := randf() * TAU
		var _scale := 0.3 + randf_range(0, 0.1)
		var _my_len := randf() * 30.0
		var _black := 0.6
		make_gunball(randi_range(0,12), _dir, _my_len, Vector2( _scale, _scale ), _black )
		
	for i in 120:
		var _dir :=  randf() * TAU
		var _scale := 0.4 + randf_range(0, 0.05)
		var _my_len := 12 + ( randf() * 30.0 )
		var _black := 0.2
		make_gunball(randi_range(0,12), _dir, _my_len, Vector2( _scale, _scale ), _black )
		
	for i in 20: ## Circle
		var _dir := (i * 18) + ( randf() * 4.0 ) # randf() * TAU
		var _scale := 0.4 + randf_range(0, 0.05)
		var _my_len := 38 + (randf() * 4.0) # + ( randf() * 30.0 )
		var _black := 0.4
		make_gunball(randi_range(0,12), _dir, _my_len, Vector2( _scale, _scale ), _black )
		
	for i in 40:
		var _dir := randf() * TAU
		var _scale := 0.5 + randf_range(0, 0.05)
		var _my_len := randf() * 35.0
		var _black := 0.0
		make_gunball(randi_range(0,12), _dir, _my_len, Vector2( _scale, _scale ), _black )
		

func make_gunball(id : int, _dir : float, _my_len : float, _scale : Vector2, _black := 0.0 ):
	var dir := _dir
	var my_len := _my_len
	
	
	var ball := Sprite2D.new()
	ball.texture = cc_gumball.gumSub[id]
	ball.modulate = cc_gumball.gumCol[id].darkened( _black )
	ball.scale = _scale
	ball.position.x = my_len
	ball.position = ball.position.rotated( dir )
	
	## Dirty hack for the outline. terrible for performance, but it works. Who cares?
	var ball_shadow := Sprite2D.new()
	ball_shadow.texture = cc_gumball.gumSub[0]
	ball_shadow.modulate = Color.BLACK
	ball_shadow.scale = ball.scale * 1.1
	ball_shadow.position = ball.position
	
	add_child(ball_shadow)
	add_child(ball)
	
func nudge(): # slightly move the balls.
	
	
	var tween := create_tween()
	tween.set_parallel( true )
	
	for ball : Sprite2D in get_children():
		var reference : Vector2 = ball.position + ball.position.direction_to( Vector2( 0, 50 ) ) * 1.5
		tween.tween_property(ball, "position", reference, 1.0)
		
	await tween.finished
	return
		
	#ball.material = ShaderMaterial.new()
	#ball.material.shader = preload("res://barkley2/resources/shaders/b2_outline.gdshader")
	#ball.material.set_shader_parameter("modulate", cc_gumball.gumCol[id].darkened( _black ) )
