@tool
extends Control

const CHARS := ['*', '+', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '<', '=', '>', '#', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', '', 'x', 'y', 'z']

@export var dna_bullshit: GridContainer

func _ready() -> void:
	if Engine.is_editor_hint():
		generate_gene( name )

func hide_gene() -> void:
	dna_bullshit.hide()

func generate_gene( _seed : String ) -> void:
	dna_bullshit.show()
	var r := RandomNumberGenerator.new()
	r.seed = hash( _seed )
	for gene in dna_bullshit.get_children():
		if gene is Label:
			gene.text = CHARS[ r.randi_range(0,CHARS.size() - 1) ]
			if r.randf() > 0.8:
				gene.modulate = Color.RED
			else:
				gene.modulate = Color.WHITE
