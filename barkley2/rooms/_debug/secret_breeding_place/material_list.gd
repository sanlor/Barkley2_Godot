extends GridContainer

const MATERIAL_DEBUG_BOX = preload("uid://br5usnc3aulv3")

@onready var line_1: Line2D = $"../line_1"
@onready var line_2: Line2D = $"../line_2"

@onready var gun_top: PanelContainer = $"../../gun_top"
@onready var gun_bottom: PanelContainer = $"../../gun_bottom"
@onready var gun_child: PanelContainer = $"../../gun_child"

var my_mat_list := {}


func _ready() -> void:
	for mat in B2_Gun_Fuse.MATERIAL.data: # Indexes the materils as row / column.
		var pos := Vector2i( B2_Gun_Fuse.MATERIAL.data[mat][B2_Gun_Fuse.ROW], B2_Gun_Fuse.MATERIAL.data[mat][B2_Gun_Fuse.COLUMN] )
		my_mat_list[pos] = B2_Gun_Fuse.MATERIAL.data[mat]
		my_mat_list[pos].append(mat)
		
	for c in 7 + 1:		# Column
		for r in 18 + 1:		# Row
		
			var mat : Array = my_mat_list.get( Vector2i(r,c), [] )
			var p := MATERIAL_DEBUG_BOX.instantiate()
			add_child(p)
			if mat.is_empty():
				if r == 0 and c == 0:
					p.clear()
				if r == 0:
					p.set_material_name( "Row" )
					p.set_material_weight( r )
					p.set_material_eletron( c )
					p.modulate = Color.RED
				elif c == 0:
					p.set_material_name( "Column" )
					p.set_material_weight( r )
					p.set_material_eletron( c )
					p.modulate = Color.YELLOW
				else:
					p.clear()
			else:
				p.mat = B2_Gun.MATERIAL_NAMES.find_key( mat.back() )
				p.set_material_name( mat.back() )
				p.set_material_weight( mat[2] )
				p.set_material_eletron( mat[3] )

## Yup, its messy, but its for debug purposes.
func _process(_delta: float) -> void:
	line_1.clear_points()
	line_2.clear_points()
	for c in get_children():
		if c.mat != B2_Gun.MATERIAL.NONE:
			c.modulate = Color.WHITE
			if gun_top.my_gun:
				if c.mat == gun_top.my_gun.weapon_material:
					c.modulate = Color.BLUE
					line_1.add_point( c.global_position + Vector2(25,25) )
			if gun_bottom.my_gun:
				if c.mat == gun_bottom.my_gun.weapon_material:
					c.modulate = Color.DARK_CYAN
					line_2.add_point( c.global_position + Vector2(25,25) )
			if gun_child.my_gun:
				if c.mat == gun_child.my_gun.weapon_material:
					c.modulate = Color.GREEN_YELLOW
					line_1.add_point( c.global_position + Vector2(25,25) )
					line_2.add_point( c.global_position + Vector2(25,25) )
				
