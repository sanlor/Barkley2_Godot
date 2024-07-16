@tool
extends Control

@export var debug := false

const CC_TAROT_CARD = preload("res://barkley2/scenes/CC/cc_tarot_card.tscn")

@onready var spin_node = $spin_node
var card_nodes := []

signal cards_hidden

const tarot_dir := Vector2(80,0)
var target_tarot_dir := tarot_dir
var spin_speed := 0.25
var time_goes_on := 0.0

var is_orbiting := true
var spinning_audio : AudioStreamPlayer

# Final position for the cards on the present_four_cards() function.
var card_presenting_positions := [ Vector2(54, 32), Vector2(124, 32), Vector2(196, 32), Vector2(266, 32) ]

func _ready():
	spinning_audio = B2_Sound.play( "sn_cc_tarot_sync", 0.0, false, INF )
	spin_cards()

func _process(delta):
	if debug:
		## DEBUG STUFF
		if Input.is_key_label_pressed(KEY_1):
			hide_cards()
		if Input.is_key_label_pressed(KEY_2):
			spin_cards()
			
	if is_orbiting:
		## Speeen.
		time_goes_on += delta
		time_goes_on = wrapf(time_goes_on, 0, TAU) # no leaky memory, ok?
		
		for i in 16:
			card_nodes[i].position = target_tarot_dir.rotated( TAU / 16 * i + time_goes_on * spin_speed)
		
func spin_cards():
	is_orbiting = true
	## Cleanup old cards if there ar any
	if not card_nodes.is_empty():
		for t in card_nodes:
			if is_instance_valid(t):
				t.queue_free()
	
	## Add new cards
	for i in 16:
		card_nodes.append( CC_TAROT_CARD.instantiate() )
		spin_node.add_child( card_nodes[i] )
		card_nodes[i].scale = Vector2( 0.5, 0.5 )
		card_nodes[i].position += target_tarot_dir.rotated( TAU / 16 * i )
	
	modulate.a = 0.0
	target_tarot_dir.x = tarot_dir.x / 2
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property( self, "modulate:a", 1.0, 2.0 						)#.set_trans(Tween.TRANS_SINE)
	tween.tween_property( self, "target_tarot_dir:x", tarot_dir.x, 1.5 		)#.set_trans(Tween.TRANS_SINE)
	await tween.finished
	
func hide_cards():
	var tween := create_tween()
	tween.tween_property( self, "target_tarot_dir:x", 0.0, 1.5 				).set_trans(Tween.TRANS_SINE)
	B2_Sound.stop( spinning_audio, true,  1.5 )
	await tween.finished
	
	is_orbiting = false
	present_four_cards()

func present_four_cards():
	## TODO CODE TO PRESENT 4 CARDS
	
	## Cleanup old cards if there ar any
	if not card_nodes.is_empty():
		for t in card_nodes:
			if is_instance_valid(t):
				t.queue_free()
				
	card_nodes.clear()
	await get_tree().process_frame
	
	for i in 4:
		card_nodes.append( CC_TAROT_CARD.instantiate() )
		card_nodes[i].scale = Vector2( 0.5, 0.5 )
		spin_node.add_child( card_nodes[i] )
		# card_nodes[i].can_be_selected = true
		
	await get_tree().create_timer(1.0).timeout
	B2_Sound.play( "sn_cc_tarot_spread" )
	
	var tween := create_tween()
	tween.set_parallel(true)
	for i in 4:
		tween.tween_property(card_nodes[i], "position", card_presenting_positions[i] - Vector2(160,55)	, 2.2).set_trans(Tween.TRANS_SINE)
		tween.tween_property(card_nodes[i], "scale", Vector2.ONE										, 2.2).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	for card in card_nodes:
		card.can_be_selected = true
		
	cards_hidden.emit()
