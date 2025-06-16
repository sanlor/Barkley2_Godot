extends Control
## Jerkin comparison.
# check oShop event 0

signal menu_closed

@onready var bg_1: TextureRect = $bg1
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var curr_jerkin_img: TextureRect = $bg1/MarginContainer/VBoxContainer/jerk_preview/curr_jerkin/curr_jerkin_img
@onready var sel_jerkin_img: TextureRect = $bg1/MarginContainer/VBoxContainer/jerk_preview/sel_jerkin/sel_jerkin_img

@onready var curr_jerkin_name: Label = $bg1/MarginContainer/VBoxContainer/jerk_preview/curr_jerkin/curr_jerkin_name
@onready var sel_jerkin_name: Label = $bg1/MarginContainer/VBoxContainer/jerk_preview/sel_jerkin/sel_jerkin_name

@onready var bal_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat1/values/bal_data_cur
@onready var bal_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat1/values/bal_data_comp
@onready var bal_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat1/values/bal_data_sel

@onready var wgt_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat2/values/wgt_data_cur
@onready var wgt_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat2/values/wgt_data_comp
@onready var wgt_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat2/values/wgt_data_sel

@onready var pkt_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat3/values/pkt_data_cur
@onready var pkt_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat3/values/pkt_data_comp
@onready var pkt_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat3/values/pkt_data_sel

@onready var bio_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat4/values/bio_data_cur
@onready var bio_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat4/values/bio_data_comp
@onready var bio_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat4/values/bio_data_sel

@onready var cyb_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat5/values/cyb_data_cur
@onready var cyb_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat5/values/cyb_data_comp
@onready var cyb_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat5/values/cyb_data_sel

@onready var men_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat6/values/men_data_cur
@onready var men_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat6/values/men_data_comp
@onready var men_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat6/values/men_data_sel

@onready var kos_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat7/values/kos_data_cur
@onready var kos_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat7/values/kos_data_comp
@onready var kos_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat7/values/kos_data_sel

@onready var zau_data_cur: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat8/values/zau_data_cur
@onready var zau_data_comp: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat8/values/zau_data_comp
@onready var zau_data_sel: Label = $bg1/MarginContainer/VBoxContainer/jerk_stats/stat8/values/zau_data_sel

var curr_jerkin 	:= ""
var sel_jerkin 		:= ""

func _setup_menu() -> void:
	if curr_jerkin.is_empty() or sel_jerkin.is_empty():
		push_error("Invalid Jerkin data.")
		breakpoint
		return
	var c := B2_Jerkin.get_jerkin_stats(curr_jerkin)
	var s := B2_Jerkin.get_jerkin_stats(sel_jerkin)
	curr_jerkin_img.texture.region.position.x 	= 24.0 * int( c	["Sub"] )
	sel_jerkin_img.texture.region.position.x 	= 24.0 * int( s	["Sub"] )
	curr_jerkin_name.text 	= curr_jerkin
	sel_jerkin_name.text 	= sel_jerkin
	
	bal_data_cur.text = str( c["Normal"] )
	bal_data_sel.text = str( s["Normal"] )
	if c["Normal"] > s["Normal"]:
		bal_data_comp.text = "<"
		bal_data_comp.modulate = Color.RED
	elif c["Normal"] < s["Normal"]:
		bal_data_comp.text = ">"
		bal_data_comp.modulate = Color.GREEN
	else:
		bal_data_comp.text = "="
		bal_data_comp.modulate = Color.GRAY
		
	wgt_data_cur.text = str( c["Wgt"] )
	wgt_data_sel.text = str( s["Wgt"] )
	if c["Wgt"] > s["Wgt"]:
		wgt_data_comp.text = ">"
		wgt_data_comp.modulate = Color.GREEN
	elif c["Wgt"] < s["Wgt"]:
		wgt_data_comp.text = "<"
		wgt_data_comp.modulate = Color.RED
	else:
		wgt_data_comp.text = "="
		wgt_data_comp.modulate = Color.GRAY
		
	pkt_data_cur.text = str( c["Pkt"] )
	pkt_data_sel.text = str( s["Pkt"] )
	if c["Pkt"] > s["Pkt"]:
		pkt_data_comp.text = "<"
		pkt_data_comp.modulate = Color.RED
	elif c["Pkt"] < s["Pkt"]:
		pkt_data_comp.text = ">"
		pkt_data_comp.modulate = Color.GREEN
	else:
		pkt_data_comp.text = "="
		pkt_data_comp.modulate = Color.GRAY
	
	bio_data_cur.text = str( c["Bio"] )
	bio_data_sel.text = str( s["Bio"] )
	if c["Bio"] > s["Bio"]:
		bio_data_comp.text = "<"
		bio_data_comp.modulate = Color.RED
	elif c["Bio"] < s["Bio"]:
		bio_data_comp.text = ">"
		bio_data_comp.modulate = Color.GREEN
	else:
		bio_data_comp.text = "="
		bio_data_comp.modulate = Color.GRAY
		
	cyb_data_cur.text = str( c["Cyber"] )
	cyb_data_sel.text = str( s["Cyber"] )
	if c["Cyber"] > s["Cyber"]:
		cyb_data_comp.text = "<"
		cyb_data_comp.modulate = Color.RED
	elif c["Cyber"] < s["Cyber"]:
		cyb_data_comp.text = ">"
		cyb_data_comp.modulate = Color.GREEN
	else:
		cyb_data_comp.text = "="
		cyb_data_comp.modulate = Color.GRAY
		
	men_data_cur.text = str( c["Mental"] )
	men_data_sel.text = str( s["Mental"] )
	if c["Mental"] > s["Mental"]:
		men_data_comp.text = "<"
		men_data_comp.modulate = Color.RED
	elif c["Mental"] < s["Mental"]:
		men_data_comp.text = ">"
		men_data_comp.modulate = Color.GREEN
	else:
		men_data_comp.text = "="
		men_data_comp.modulate = Color.GRAY
		
	kos_data_cur.text = str( c["Kosmic"] )
	kos_data_sel.text = str( s["Kosmic"] )
	if c["Kosmic"] > s["Kosmic"]:
		kos_data_comp.text = "<"
		kos_data_comp.modulate = Color.RED
	elif c["Kosmic"] < s["Kosmic"]:
		kos_data_comp.text = ">"
		kos_data_comp.modulate = Color.GREEN
	else:
		kos_data_comp.text = "="
		kos_data_comp.modulate = Color.GRAY
		
	zau_data_cur.text = str( c["Zauber"] )
	zau_data_sel.text = str( s["Zauber"] )
	if c["Zauber"] > s["Zauber"]:
		zau_data_comp.text = "<"
		zau_data_comp.modulate = Color.RED
	elif c["Zauber"] < s["Zauber"]:
		zau_data_comp.text = ">"
		zau_data_comp.modulate = Color.GREEN
	else:
		zau_data_comp.text = "="
		zau_data_comp.modulate = Color.GRAY

func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
			if Input.is_action_just_pressed("Action") or Input.is_action_just_pressed("Holster"):
				hide_menu()

func show_panel( _sel_jerkin : String ) -> void:
	sel_jerkin = _sel_jerkin
	curr_jerkin = B2_Jerkin.get_current_jerkin()
	_setup_menu()
	animation_player.play("show")
	grab_focus()

func hide_menu() -> void:
	if not animation_player.is_playing():
		animation_player.play("hide")
		await animation_player.animation_finished
		menu_closed.emit()

## Cool effect
func _physics_process(_delta: float) -> void:
	if visible:
		queue_redraw()

var n_prev_rect := 5
var prev_rect : Array[Rect2] = []
func _draw() -> void:
	prev_rect.append( Rect2(bg_1.position, bg_1.size) )
	for rect in prev_rect:
		draw_rect( rect, Color.GREEN * randf_range(0.55,1.55), false )
	if prev_rect.size() > n_prev_rect:
		prev_rect.pop_front()
