extends B2_Environ

@export var ui_label : Label
@export var gambler_label : Label
@export var rupee_1 : AnimatedSprite2D
@export var rupee_2 : AnimatedSprite2D
@export var rupee_3 : AnimatedSprite2D

var greetings := "Hello, I am Kelpzinsky. Let's play#money making game.";

var t : Tween
var _choice_made := false

func _ready() -> void:
	## Debug stuff
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Gambler is broke #
	if B2_Playerdata.Quest("moneyGameProfit") >= B2_Database.money_check_value("moneyMakingGameUpperLimit"):
		greetings = "You son of a bitch! I don't have#a penny left!"
		rupee_1.queue_free()
		rupee_2.queue_free()
		rupee_3.queue_free()

	# You are broke #
	if B2_Config.get_user_save_data("player.shekels", 0) < B2_Database.money_check_value("moneyMakingGameCost"):
		greetings = "Looks like you don't have enough#money for the money making game!"
		rupee_1.queue_free()
		rupee_2.queue_free()
		rupee_3.queue_free()
		
	# Stats #
	var goofster_a : int = B2_Database.money_check_value("moneyMakingResult01");
	var goofster_b : int = B2_Database.money_check_value("moneyMakingResult02");
	var goofster_c : int = B2_Database.money_check_value("moneyMakingResult03");
	var goofster_d : int = B2_Database.money_check_value("moneyMakingResult04");
	var value = [goofster_a, goofster_b, goofster_c, goofster_d]
	value.shuffle()
	rupee_1.value = value.pop_front()
	rupee_2.value = value.pop_front()
	rupee_3.value = value.pop_front()
		
	rupee_1.hoopz_touched_rupee.connect( choice_made )
	rupee_2.hoopz_touched_rupee.connect( choice_made )
	rupee_3.hoopz_touched_rupee.connect( choice_made )
		
	display_text()
		
func choice_made( value : int ) -> void:
	if _choice_made: return
	_choice_made = true
	
	rupee_1.disable_rupee()
	rupee_2.disable_rupee()
	rupee_3.disable_rupee()
	
	B2_Config.set_user_save_data( "player.shekels", max(B2_Config.get_user_save_data("player.shekels", 0) + value, 0) )
	B2_Playerdata.Quest("moneyGameProfit", B2_Playerdata.Quest("moneyGameProfit",null,0) + value); 
	if value < 0:
		greetings = "Ha ha ha! Eat my dick! You lost!";
	else:
		greetings = "Wow, nice work! Visit me again!";
	display_text()
		
func display_text() -> void:
	gambler_label.text = Text.pr( greetings )
	gambler_label.visible_characters = 0
	
	var increase_text := func():
		gambler_label.visible_characters += 1
		B2_Sound.play("sn_bubblepop01")
	
	if t: t.kill()
	t = create_tween()
	
	for i in gambler_label.text.length():
		t.tween_callback( increase_text )
		t.tween_interval( 0.05 )
		
func _process(_delta: float) -> void:
	ui_label.text = Text.pr( "Current shekels: %s" % int( B2_Config.get_user_save_data("player.shekels", 0) ) )
