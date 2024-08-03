extends GPUParticles2D

var my_size := 10

@onready var ring_day = $"../ring_day"
@onready var ring_month = $"../ring_month"
@onready var ring_year = $"../ring_year"
@onready var finish_button = $"../finish_button"

@onready var following_node : AnimatedSprite2D = ring_day

func _ready():
	process_material.emission_sphere_radius = my_size
	
	# peaceout after the player enter its data.
	get_parent().zodiac_entered.connect( queue_free )
	ring_day.activated_next_dial.connect(_change_f_node)
	ring_month.activated_next_dial.connect(_change_f_node)
	ring_year.activated_next_dial.connect(_change_f_node)
	
func _change_f_node(node):
	following_node = node
	if node.can_rotate:
		my_size = 10
	else:
		my_size = 20
	
func _process(_delta):
	# ensures that the jewel shild is on top of the active jewel.
	global_position = following_node.global_position + following_node.button_position.rotated( following_node.rotation ) # holy shit!
