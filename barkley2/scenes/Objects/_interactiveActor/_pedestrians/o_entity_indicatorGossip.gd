#@tool
extends Control

@onready var gossip_panel: PanelContainer = $gossip_panel
@onready var gossip_text: Label = $gossip_panel/CenterContainer/gossip_text


var original_pos := Vector2(-72,-20)

# Timer before delete
var timer := 5.0;

# Text to show #
var text := "Gossip";

var vel := Vector2.ZERO

var max_bounce 	:= 5
var bounce 		:= 0

func _ready() -> void:
	vel = Vector2( 0,220 )
	gossip_text.text = Text.pr( text )
	
	await get_tree().process_frame
	gossip_panel.set_anchors_preset(Control.PRESET_CENTER)
	
	var tween := create_tween()
	tween.tween_interval( timer )
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.tween_callback( queue_free )
	
func _physics_process(delta: float) -> void:
	if bounce > max_bounce:
		return
		
	if gossip_panel.position.y > original_pos.y:
		gossip_panel.position.y = original_pos.y + 1
		vel.y /= 1.5
		vel.y *= -1
		bounce += 1
	
	gossip_panel.position.y -= vel.y * delta
	vel.y -= 400.0 * delta
