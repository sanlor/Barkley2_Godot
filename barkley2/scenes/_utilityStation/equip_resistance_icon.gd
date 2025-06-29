extends HBoxContainer

enum RES{NORMAL,BIO,CYBER,MENTAL,COSMIC,ZAUBER}
@export var resistance := RES.NORMAL
enum TYPE{JERKIN,HELM}
@export var equip_type := TYPE.HELM
@onready var res_tex: 		TextureRect 	= $res_tex
@onready var res_value: 	Label 			= $res_value

var my_equip_name := ""

func _ready() -> void:
	match resistance:
		RES.NORMAL:			pass
		RES.BIO:			res_tex.modulate = B2_Gamedata.c_bio
		RES.CYBER:			res_tex.modulate = B2_Gamedata.c_cyber
		RES.MENTAL:			res_tex.modulate = B2_Gamedata.c_mental
		RES.COSMIC:			res_tex.modulate = B2_Gamedata.c_cosmic
		RES.ZAUBER:			res_tex.modulate = B2_Gamedata.c_zauber
	update_data()
	
func update_data() -> void:
	if not is_node_ready():
		return
		
	if equip_type == TYPE.HELM:
		match resistance:
			RES.NORMAL: 	res_value.text =	str( 0 ).pad_zeros(2)
			RES.BIO: 		res_value.text =	str( 0 ).pad_zeros(2)
			RES.CYBER: 		res_value.text =	str( 0 ).pad_zeros(2)
			RES.MENTAL: 	res_value.text =	str( 0 ).pad_zeros(2)
			RES.COSMIC: 	res_value.text =	str( 0 ).pad_zeros(2)
			RES.ZAUBER: 	res_value.text =	str( 0 ).pad_zeros(2)
	elif equip_type == TYPE.JERKIN:
		match resistance:
			RES.NORMAL: 	res_value.text =	str( B2_Jerkin.get_jerkin_stats(my_equip_name)["Normal"] ).pad_zeros(2)
			RES.BIO: 		res_value.text =	str( B2_Jerkin.get_jerkin_stats(my_equip_name)["Bio"] ).pad_zeros(2)
			RES.CYBER: 		res_value.text =	str( B2_Jerkin.get_jerkin_stats(my_equip_name)["Cyber"] ).pad_zeros(2)
			RES.MENTAL: 	res_value.text =	str( B2_Jerkin.get_jerkin_stats(my_equip_name)["Mental"] ).pad_zeros(2)
			RES.COSMIC: 	res_value.text =	str( B2_Jerkin.get_jerkin_stats(my_equip_name)["Kosmic"] ).pad_zeros(2)
			RES.ZAUBER: 	res_value.text =	str( B2_Jerkin.get_jerkin_stats(my_equip_name)["Zauber"] ).pad_zeros(2)

func _on_visibility_changed() -> void:
	if visible: update_data()
