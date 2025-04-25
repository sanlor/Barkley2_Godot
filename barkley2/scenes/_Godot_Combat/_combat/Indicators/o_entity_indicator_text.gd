extends Node2D

@onready var header_l: Label = $header
@onready var subtext_l: Label = $header/subtext

var header 	:= ""
var subtext := ""

func setup_labels( _header : String, _subtext : String ) -> void:
	header 	= _header
	subtext = _subtext

func _ready() -> void:
	header_l.text 	= header
	subtext_l.text 	= subtext
	
	var t := create_tween()
	t.tween_property(header_l, "position:y", randf_range(-48.0,-72.0), randf_range(0.5,1.5) ).set_trans(Tween.TRANS_ELASTIC)
	#t.tween_property(header_l, "position:y", 0, randf_range(0.2,0.5) ).set_trans(Tween.TRANS_ELASTIC)
	t.tween_interval( 1.0 )
	t.tween_property( self, "modulate", Color.TRANSPARENT, 0.5 )
	t.tween_callback( queue_free )
