extends Control

## Card 15 is special. the Crack'd dome skips... something.

## Card 9 asks you to pick another card. it draws 2 buttons somewhere with 2 options
#option_yes = "New card";
#option_no = "Keep it";
#option_hover[0] = scr_cc_button_xy(26, 358, 200, 210);
#option_hover[1] = scr_cc_button_xy(26, 358, 211, 220);

## o_cc_effect_tarot_candles seems important

@export var debug := false

const CC_TAROT_CARD = preload("res://barkley2/scenes/CC/cc_tarot_card.tscn")

@onready var spin_node = $spin_node
var card_nodes := []

signal cards_hidden
signal card_selected( card_id )
signal all_cards_selected

const tarot_dir := Vector2(80,0)
var target_tarot_dir := tarot_dir
var spin_speed := 0.25
var time_goes_on := 0.0

var is_orbiting := true
var spinning_audio : AudioStreamPlayer

var is_spinning := false
var spinning_card := 0 # 0 to 3 only

var card_index := [0, 0, 0, 0]
var cards_picked := 0

# Final position for the cards on the present_four_cards() function.
var card_presenting_positions := [ Vector2(54, 32), Vector2(124, 32), Vector2(196, 32), Vector2(266, 32) ]

func _ready():
	spinning_audio = B2_Sound.play( "sn_cc_tarot_sync", 0.0, false, INF )
	## Similar setup to the original.
	
	var shuffled_deck := []
	var shuffled_special_deck := []
	for i in 22: # Original comment -> // was 22, now 21 to remove babe in the woods ## I decided to add it back in. no idea why it was removed.
		shuffled_deck.append(i)
	for i in 3:
		shuffled_special_deck.append(i)
		
	assert( not shuffled_deck.has( 22 ) ) ## DEBUG
	shuffled_deck.append( 22 ) # // Rules card
	
	shuffled_deck.shuffle()
	shuffled_special_deck.shuffle()
	
	card_index[0] = 2 + shuffled_deck[0]
	card_index[1] = 2 + shuffled_deck[1]
	card_index[2] = 2 + shuffled_deck[2]
	card_index[3] = 2 + shuffled_deck[3]
	
	# Change fortune card if it isn't the firts draw #
	if card_index[0] != 11:
		if card_index[1] == 11: card_index[1] = 25;
		elif card_index[2] == 11: card_index[2] = 25;
		elif card_index[3] == 11: card_index[3] = 25;
		 
	# Maybe there was a special card... // Reroll cards for a sepcial card. If it happens, it happens #
	var card_special = randi_range(0,100);
	if card_special <= 4: card_index[0] = 26 + shuffled_special_deck[0] #ds_list_find_value(card_list_2, 0);
	elif card_special <= 8: card_index[1] = 26 + shuffled_special_deck[1] #ds_list_find_value(card_list_2, 1);
	elif card_special <= 12: card_index[2] = 26 + shuffled_special_deck[2]# ds_list_find_value(card_list_2, 2);
	
	orbit_cards()

func _process(delta):
	if debug:
		## DEBUG STUFF
		if Input.is_key_label_pressed(KEY_1):
			hide_cards()
		if Input.is_key_label_pressed(KEY_2):
			orbit_cards()
		if Input.is_key_label_pressed(KEY_3):
			#spin_card()
			pass
			
	if is_orbiting:
		## Speeen.
		time_goes_on += delta
		time_goes_on = wrapf(time_goes_on, 0, TAU) # no leaky memory, ok?
		
		for i in 16:
			card_nodes[i].position = target_tarot_dir.rotated( TAU / 16 * i + time_goes_on * spin_speed)


func spin_card( card_id : int ):
	spinning_card = card_id
	var spin_speed := 0.08
	B2_Sound.play("sn_cc_tarot_flip")
	var card : AnimatedSprite2D = card_nodes[spinning_card]
	var spin_tween := create_tween()
	for i in 3:
		spin_tween.tween_property(card, "scale:x", 0.0, spin_speed)
		spin_tween.tween_callback( flip_card.bind(card, card_index[ cards_picked ], true) )
		spin_tween.tween_property(card, "scale:x", 1.0, spin_speed)
		if i != 2:
			spin_tween.tween_property(card, "scale:x", 0.0, spin_speed)
			spin_tween.tween_callback( flip_card.bind(card, card_index[ cards_picked ], false) )
			spin_tween.tween_property(card, "scale:x", 1.0, spin_speed)
			
	card_selection(false)
	# check if all cards are picked
	if cards_picked > 3:
		all_cards_selected.emit()
	else: # if not, continue
		card_selected.emit( card_index[ cards_picked ] )
		cards_picked += 1

func flip_card(card : AnimatedSprite2D, frame : int, is_flipped : bool ):
	if is_flipped:
		card.frame = frame
	else:
		card.frame = 0

func card_selection( enabled : bool):
	for card in card_nodes:
		card.can_be_selected = enabled

func orbit_cards():
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
		card_nodes[i].card_pressed.connect( func(): spin_card( i ) )
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
