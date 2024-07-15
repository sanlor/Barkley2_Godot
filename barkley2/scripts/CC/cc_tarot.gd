@tool
extends Control

const CC_TAROT_CARD = preload("res://barkley2/scenes/CC/cc_tarot_card.tscn")

@onready var spin_node = $spin_node
var card_nodes := []

signal cards_hidden

var tarot_dir := Vector2(100,0)
var spin_speed := 
var time_goes_on := 0.0

func _ready():
	for i in 16:
		card_nodes.append( CC_TAROT_CARD.instantiate() )
		spin_node.add_child( card_nodes[i] )
		card_nodes[i].scale = Vector2( 0.5, 0.5 )
		card_nodes[i].position += tarot_dir.rotated( TAU / 16 * i )
	pass

func _process(delta):
	for i in 16:
		card_nodes[i].position = card_nodes[i].position.rotated( TAU / 16 * i )
		
func spin_cards():
	pass
	
func hide_cards():
	pass
