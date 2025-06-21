extends VBoxContainer

@export var gun_info		: B2_UtilityPanel
@export var gun_info_slots 	: VBoxContainer

@onready var gun_reload_all: Button = $gun_reload_all
@onready var gun_reload_gun_1: Button = $gun_reload_gun1
@onready var gun_reload_gun_2: Button = $gun_reload_gun2
@onready var gun_reload_gun_3: Button = $gun_reload_gun3

var bando : Array[B2_Weapon]

func _ready() -> void:
	gun_reload_all.focus_entered.connect( highlight_all.bind(true) )
	gun_reload_all.mouse_entered.connect( highlight_all.bind(true) )
	gun_reload_gun_1.focus_entered.connect( highlight_slot.bind(0,true) )
	gun_reload_gun_1.mouse_entered.connect( highlight_slot.bind(0,true) )
	gun_reload_gun_2.focus_entered.connect( highlight_slot.bind(1,true) )
	gun_reload_gun_2.mouse_entered.connect( highlight_slot.bind(1,true) )
	gun_reload_gun_3.focus_entered.connect( highlight_slot.bind(2,true) )
	gun_reload_gun_3.mouse_entered.connect( highlight_slot.bind(2,true) )
	
	gun_reload_all.focus_exited.connect( highlight_all )
	gun_reload_all.mouse_exited.connect( highlight_all )
	gun_reload_gun_1.focus_exited.connect( highlight_slot.bind(0) )
	gun_reload_gun_1.mouse_exited.connect( highlight_slot.bind(0) )
	gun_reload_gun_2.focus_exited.connect( highlight_slot.bind(1) )
	gun_reload_gun_2.mouse_exited.connect( highlight_slot.bind(1) )
	gun_reload_gun_3.focus_exited.connect( highlight_slot.bind(2) )
	gun_reload_gun_3.mouse_exited.connect( highlight_slot.bind(2) )

func _on_visibility_changed() -> void:
	if is_node_ready():
		update_btns()
	
func update_btns() -> void:
	gun_reload_all.hide()
	gun_reload_gun_1.hide()
	gun_reload_gun_2.hide()
	gun_reload_gun_3.hide()
	
	bando = B2_Gun.get_bandolier()
	
	if bando.size() != 0:
		gun_reload_all.show()
		gun_reload_gun_1.show()
		gun_reload_gun_1.text = bando[0].get_short_name()
	if bando.size() == 2:
		gun_reload_gun_2.show()
		gun_reload_gun_2.text = bando[1].get_short_name()
	if bando.size() == 3:
		gun_reload_gun_3.show()
		gun_reload_gun_3.text = bando[2].get_short_name()
		
func highlight_all( enabled := false ) -> void:
	for slot in gun_info_slots.get_children():
		slot.select( enabled )
	
func highlight_slot( slot : int, enabled := false ) -> void:
	if slot <= gun_info_slots.get_children().size():
		gun_info_slots.get_children()[ slot ].select( enabled )
	else:
		push_error("Slot overflow: %s - %s." % [str(slot), str(gun_info_slots.get_children().size())])

func _update_slots() -> void:
	for slot in gun_info_slots.get_children():
		slot.update_data()
	if gun_info:
		gun_info.update_smelt()
	B2_Sound.play( "acid_impact" )

func _physics_process(delta: float) -> void:
	if visible:
		if gun_reload_all.button_pressed:
			if _can_update( delta ):
				for gun in bando:
					if gun.recover_ammo( 1 ):
						use_smelt_point()
						_update_slots()
					
		elif gun_reload_gun_1.button_pressed:
			if _can_update( delta ):
				if bando.size() >= 1:
					if bando[0].recover_ammo( 1 ):
						use_smelt_point()
						_update_slots()
					
		elif gun_reload_gun_2.button_pressed:
			if _can_update( delta ):
				if bando.size() >= 2:
					if bando[1].recover_ammo( 1 ):
						use_smelt_point()
						_update_slots()
					
		elif gun_reload_gun_3.button_pressed:
			if _can_update( delta ):
				if bando.size() >= 3:
					if bando[2].recover_ammo( 1 ):
						use_smelt_point()
						_update_slots()
			
var t := 0.0
func _can_update( delta : float ) -> bool:
	t -= 8.0 * delta
	#print(t)
	if t < 0.0:
		t = 0.65
		return true
	else:
		return false
	
			
func has_smelt_points() -> bool:
	return not B2_Config.get_user_save_data("ustation.smelt", 0.0) <= 0.0

func use_smelt_point() -> void:
	B2_Config.set_user_save_data( "ustation.smelt", B2_Config.get_user_save_data("ustation.smelt", 0.0) - 1.0 )
