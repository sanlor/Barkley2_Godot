extends ConfirmationDialog

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
	
func populate_map_tree() -> void:
	tree_node.clear()
	tree_root = tree_node.create_item()
	tree_node.hide_root = true
	
	for item : String in MAP_ORDER.keys():
		var treeitem := tree_node.create_item(tree_root)
		treeitem.set_text( 0, MAP_ORDER[item] )
		
		for room : String in B2_RoomXY.room_index.keys():
			if room.contains(item):
				#treeitem.add_button( 0, Texture2D.new(), -1, false, room, room )
				var room_item := tree_node.create_item( treeitem )
				room_item.set_text( 0, room )
				map_order[room_item] = room

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
	B2_RoomXY.fancy_warp_to( room_name, 0, 0 )
	
