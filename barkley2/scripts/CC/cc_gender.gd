#@tool
extends Control

signal accept_pressed

@onready var gender_frame_bg = $gender_frame_bg
@onready var gender_frame_bg_2 = $gender_frame_bg2

@onready var gender_frame = $gender_frame
@onready var gender_image_frame = $gender_image_frame
@onready var gender_image_mod = $gender_image_frame/gender_image_mod

@onready var accept_btn = $accept_btn
@onready var accept_btn_bg = $accept_btn_bg

var gender_portraits := [
	
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_gender_portraits_1.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_gender_portraits_2.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_gender_portraits_3.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_gender_portraits_4.png"),
	preload("res://barkley2/assets/b2_original/images/cc/s_cc_gender_portraits_5.png"),
	]
var gender_portraits_canvas := [] # Empty textureRects that the portraits are added.

@onready var gender_image = $gender_image_frame/gender_image

const CC_GENDER_BUTTON = preload("res://barkley2/scenes/CC/cc_blood_button.tscn")
const S_CC_GENDER_CHECKMARK_0 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gender_checkmark_0.png")

@onready var r_cc = get_parent()

const GENDER_WARNING = preload("res://barkley2/scenes/CC/warning_bg.tscn")

var avaiable_genders := ["Male", "Female", "Dwarf", "Eunuch", "Other", "Mega Eunuch"] # Mega Eunuch? looks like its something unfinished.
var selected_genders := [false, false, false, false, false, false]
var is_accept_btn_clicable := false
var accept_is_hovering := false
var new_game_plus := false;

var gender_checkbox := []

func _ready():
	modulate.a = 0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	
	gender_frame_bg.set_position		( Vector2(73, 54) )
	gender_frame_bg.set_end			( Vector2(206, 190) )
	gender_frame_bg_2.set_position	( Vector2(218, 54) )
	gender_frame_bg_2.set_end		( Vector2(302, 190) )
	
	gender_frame.set_position( Vector2(140, 120) 		- (gender_frame.size / 2) 		)
	gender_image_frame.set_position( Vector2(260, 120) 	- (gender_image_frame.size / 2) )
	
	accept_btn.set_position( Vector2(192,210) - (accept_btn.size / 2) )
	
	gender_image.texture = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gender_portraits_0.png")
	gender_image.set_global_position( Vector2(260, 124) - Vector2(32,64) )
	
	# Setup accept button
	accept_btn_bg.mouse_entered.connect( func(): accept_is_hovering = true )
	accept_btn_bg.mouse_exited.connect( func(): accept_is_hovering = false )
	
	gender_portraits_canvas.resize(5)
	for i in 5:
		gender_portraits_canvas[i] = TextureRect.new()
		gender_image_frame.add_child( gender_portraits_canvas[i] )
		gender_portraits_canvas[i].texture = gender_portraits[i]
		gender_portraits_canvas[i].set_global_position( gender_image.get_global_position() )
		gender_portraits_canvas[i].visible = false
	
	for i in 6:
		var gender_label := Label.new()
		gender_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		if i == 5 and not new_game_plus:
			gender_label.text = "???"
			gender_label.modulate = Color.DARK_GRAY
		else:
			gender_label.text = avaiable_genders[i]
			#gender_label.modulate = Color.DARK_GRAY
		
		gender_frame.add_child( gender_label )
		gender_label.global_position = Vector2(111, 63 + i * 20)
		
		## Add Checkmarks
		var check := CC_GENDER_BUTTON.instantiate()
		check.can_toggle = true
		check.texture = S_CC_GENDER_CHECKMARK_0
		if i == 5 and not new_game_plus:
			check.is_disabled = true
			
		add_child( check )
		check.global_position = Vector2(86, 65 + i * 20)
		check.modulate.a = 0.0
		check.pressed.connect( toggle_buttons )
		gender_checkbox.append(check)
	
	change_gender_image()

func toggle_buttons( _selected_node : TextureRect ):
	B2_Sound.play("sn_cc_generic_button1")
	var index := 0
	for btn in gender_checkbox:
		selected_genders[index] = btn.is_selected
		index += 1
	change_gender_image()

func change_gender_image():
	var is_anything_selected := false
	for i in 5:
		if i == 3:
			gender_portraits_canvas[i].visible = not selected_genders[i] # Eunuch
		else:
			gender_portraits_canvas[i].visible = selected_genders[i]
		if selected_genders[i]:
			is_anything_selected = true
			
	is_accept_btn_clicable = is_anything_selected

func _process(_delta):
	if accept_is_hovering:
		accept_btn_bg.color = Color(0.157, 0.745, 0.98, 0.5)
		if is_accept_btn_clicable:
			if Input.is_action_just_pressed("Action"):
				check_selected_genders()
		else:
			pass
	else:
		accept_btn_bg.color = Color(0.235, 0, 0.353, 0.5)

func check_selected_genders():
	var n := 0
	
	for i in selected_genders:
		if i == true:
			n += 1
	if n >= 4:
		B2_Sound.play("sn_cc_button_accept")
		## TODO display popup - too many genders
		var warning = GENDER_WARNING.instantiate()
		
		warning.popup_warning 	= Text.pr("Warning!##Gender limit exceeded.#Continue anyway?")
		warning.popup_yes 		= Text.pr("Yes");
		warning.popup_no 		= Text.pr("No");
		
		add_child( warning )
		var choice = await warning.choice_has_been_made
		
		if not choice:
			return
		
	elif n == 0: ## This was disabled in the original code, I added it for fun.
		B2_Sound.play("sn_cc_button_cancel")
		push_warning("No gender selected. this should not be possible.")
		return
	else:
		B2_Sound.play("sn_cc_button_accept")
		r_cc.wizard_is_emoting()
		
		## TODO port this.
		#// Get gender raw and gender name
		#genderRaw = "";
		#for (i=0; i<6; i+=1;) if (option_checked[i]) genderRaw += option[i];
		#Quest("playerCCGender", genderRaw);
		#Quest("playerCCGenderName", ds_map_find_value(global.genderMap, genderRaw));
		
		B2_Playerdata.character_gender = selected_genders
		genderbox_hide()
		
func genderbox_hide():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	accept_pressed.emit()
	queue_free()
		
