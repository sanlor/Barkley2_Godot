extends CollisionShape2D
class_name B2_Minigame_VRW_Untamo

@onready var untamo_body: 	AnimatedSprite2D = $untamo_body
@onready var untamo_head: 	AnimatedSprite2D = $untamo_head
@onready var untamo_mouth: 	AnimatedSprite2D = $untamo_mouth
@onready var untamo_eyes: 	AnimatedSprite2D = $untamo_eyes
@onready var untamo_nose: 	AnimatedSprite2D = $untamo_nose
@onready var untamo_hair: 	AnimatedSprite2D = $untamo_hair
@onready var untamo_emote: 	AnimatedSprite2D = $untamo_emote


func set_head( id : int ) -> void:
	untamo_head.frame = id
	
func set_eyes( id : int ) -> void:
	untamo_eyes.frame = id
	
func set_hair( id : int ) -> void:
	untamo_hair.frame = id
	
func set_nose( id : int ) -> void:
	untamo_nose.frame = id

func set_mouth( id : int ) -> void:
	untamo_mouth.frame = id

func set_hair_color( c : Color ) -> void:
	untamo_hair.modulate = c

func set_head_color( c : Color ) -> void:
	untamo_head.modulate = c
	untamo_nose.modulate = c
	
func set_body_color( c : Color ) -> void:
	untamo_body.modulate = c
