extends PanelContainer

## Static pool. fuck this, its only used once too.

@onready var options_list: VBoxContainer = $MarginContainer/VBoxContainer/options_list
@onready var result_list: VBoxContainer = $MarginContainer/VBoxContainer/result_list

@onready var vote_btn: Button = $MarginContainer/VBoxContainer/result_list/vote_btn
@onready var vote_result: Label = $MarginContainer/VBoxContainer/result_list/vote_result

var selected_opt := 0

func _ready() -> void:
	if B2_DNET.Store("apple_pool"):
		## HAAAAAAAAAAAACK
		options_list.get_children()[ B2_DNET.Store("apple_pool") - 1 ].button_pressed = true
		options_list.get_children()[ B2_DNET.Store("apple_pool") - 1 ]._on_pressed()
		_on_vote_btn_pressed()
		return
		
	vote_btn.show()
	vote_result.hide()

func _on_vote_btn_pressed() -> void:
	var can_vote := false
	
	var index := 1
	for b : Button in options_list.get_children():
		if b.button_pressed:
			can_vote = true
			selected_opt = index
			break
		else:
			index += 1
			
	if can_vote:
		vote_btn.hide()
		vote_result.show()
		
		for b in options_list.get_children():
			if b is Button:
				b.focus_mode = Control.FOCUS_NONE
				b.disabled = true
				b.show_percentage()
				
	B2_DNET.Store("apple_pool", selected_opt)
