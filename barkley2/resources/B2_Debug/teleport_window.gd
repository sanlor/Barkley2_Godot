extends ConfirmationDialog

const FN_2 = preload("uid://cbgm2fhhwo0ld")
const FN_SMALL = preload("uid://c5asr1c5g1w6h")

const MAP_ORDER := {
	"air": "AI Ruins",
	"bct": "Brain City",
	"chu": "Cuchu Lair",
	"dth": "Death Tower",
	"est": "Eastelands",
	"fct": "Factory",
	"far": "Fary Forest",
	"pea": "Gilbert's Peak",
	"pri": "The Hoosegow",
	"ice": "Icelands",
	"min": "Mines",
	"sw1": "Sewers1",
	"sw2": "Sewers2",
	"swp": "Swamps",
	"tnn": "Tir Na Nog",
	"usw": "Undersewer",
	"wst": "Westelands",
	"pdt": "Ys-Kolob",
	"gau": "Gauntlet",
	"etc": "Etcetera",
}
var map_order : Dictionary[TreeItem, String] = {}

@onready var tree_node: Tree = $tree_node
var tree_root : TreeItem

func _ready() -> void:
	populate_map_tree()
	
	if OS.has_feature("web"):
		mode = Window.MODE_FULLSCREEN
		content_scale_factor = 1.0
	else:
		mode = Window.MODE_WINDOWED
		content_scale_factor = 2.0
	
func populate_map_tree() -> void:
	tree_node.clear()
	tree_root = tree_node.create_item()
	tree_node.hide_root = true
	
	for item : String in MAP_ORDER.keys():
		var treeitem := tree_node.create_item(tree_root)
		treeitem.set_text( 0, MAP_ORDER[item] )
		treeitem.set_custom_font( 0, FN_2 )
		treeitem.set_custom_color( 0, Color.GREEN)
		for room : String in B2_RoomXY.room_index.keys():
			if room.contains(item):
				#treeitem.add_button( 0, Texture2D.new(), -1, false, room, room )
				var room_item := tree_node.create_item( treeitem )
				room_item.set_text( 0, room )
				room_item.set_custom_font( 0, FN_SMALL )
				map_order[room_item] = room
		treeitem.collapsed = true

func _on_tree_node_item_activated() -> void:
	var treeitem := tree_node.get_selected()
	var sel = map_order.get(treeitem, null)
	if sel:
		teleport_room( map_order[treeitem] )
		hide()

func _on_confirmed() -> void:
	var treeitem := tree_node.get_selected()
	var sel = map_order.get(treeitem, null)
	if sel:
		teleport_room( map_order[treeitem] )
		hide()

func teleport_room( room_name : String ) -> void:
	push_warning("Teleporting to a room with some Temp stats")
	B2_Config.select_user_slot( 100 )
	B2_Playerdata.preload_skip_tutorial_save_data()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Music.stop( 2.0 )
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	B2_RoomXY.fancy_warp_to( room_name, 0, 0 )
	
func _on_canceled() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
