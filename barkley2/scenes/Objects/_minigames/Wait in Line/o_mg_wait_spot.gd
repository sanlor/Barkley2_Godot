extends Sprite2D
class_name B2_MiniGame_Mortage_Spot

signal new_spot_holder_registered

const SPOT_EMPTY 		:= Color("00ff0080")
const SPOT_PEDESTRIAN 	:= Color("ff000080")
const SPOT_HOOPZ		:= Color("0000ff80")

@export var o_mg_wait_control01 : Sprite2D

var spot_detection_place: Area2D
var collision_shape_2d: CollisionShape2D

var spot_holder			: RigidBody2D

func _ready() -> void:
	## Setup detection stuff
	spot_detection_place = Area2D.new()
	collision_shape_2d = CollisionShape2D.new()
	collision_shape_2d.shape = CircleShape2D.new()
	collision_shape_2d.shape.radius = 12.0
	
	## setup signals
	spot_detection_place.body_entered.connect( _register_holder )
	spot_detection_place.body_exited.connect( _unregister_holder )
	
	## Make some kids
	spot_detection_place.add_child(collision_shape_2d)
	add_child(spot_detection_place)
	
	## color stuff
	collision_shape_2d.debug_color = SPOT_EMPTY
	
	hide()

func _register_holder( node : Node2D ) -> void:
	if node is B2_PlayerCombatActor or node is B2_Pedestrian_Mortgage:
		if not spot_holder:
			## Only register if the spor is vacant
			
			if node is B2_PlayerCombatActor: 
				if o_mg_wait_control01.check_if_spot_can_register_hoopz( o_mg_wait_control01.get_spot_id(self) ):
					collision_shape_2d.debug_color = SPOT_HOOPZ
					spot_holder = node
					new_spot_holder_registered.emit()
			if node is B2_Pedestrian_Mortgage: 
				collision_shape_2d.debug_color = SPOT_PEDESTRIAN
				spot_holder = node
				new_spot_holder_registered.emit()
	
func _unregister_holder( node : Node2D ) -> void:
	if node is B2_PlayerCombatActor or node is B2_Pedestrian_Mortgage:
		if spot_holder == node:
			spot_holder = null
			collision_shape_2d.debug_color = SPOT_EMPTY
			
			## Check if there ar others actors already on the spot.
			if spot_detection_place.has_overlapping_bodies():
				for body in spot_detection_place.get_overlapping_bodies():
					if body is B2_PlayerCombatActor:
						if o_mg_wait_control01.check_if_spot_can_register_hoopz( o_mg_wait_control01.get_spot_id(self) ):
							_register_holder( body )
					if body is B2_Pedestrian_Mortgage:
						_register_holder( body )
						break

## peds use this function to check if they can move.
func can_enter( source_ped ) -> bool:
	return spot_holder == null or spot_holder == source_ped
