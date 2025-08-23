extends CanvasLayer
class_name B2_MiniGame_Document

@onready var bg: ColorRect = $bg
@onready var frame: TextureRect = $frame
@onready var document_underline: TextureRect = $document_underline


@onready var document_title_lbl: 	Label 			= $frame/PanelContainer/document_title_lbl
@onready var document_content_lbl: 	Label 			= $frame/document_content_lbl
@onready var document_page_lbl: 	Label 			= $document_underline/document_page_lbl
@onready var document_arrow_right: 	TextureButton 	= $document_underline/document_arrow_right
@onready var document_arrow_left: 	TextureButton 	= $document_underline/document_arrow_left


var document_title 	:= "Title"
var document_page	:= [
	"Page shit goes here, and it is shit there is no doubt about that I think.",
	"Page shit goe",
	"Page shit goe 123",
	]
var page_tween	: Tween
var curr_page	:= 0 :
	set(p):
		curr_page = clampi( p, 0, document_page.size() - 1)


func _enter_tree() -> void:
	B2_CManager.event_lock = true
	B2_Input.can_fast_forward = false
	
func _finish_reading() -> void:
	bg.modulate 					= Color.WHITE
	frame.modulate 					= Color.WHITE
	document_underline.modulate 	= Color.WHITE
	var t := create_tween()
	t.set_parallel( true )
	t.tween_property( bg, "modulate", Color.TRANSPARENT, 0.5 )
	t.tween_property( frame, "modulate", Color.TRANSPARENT, 0.5 )
	t.tween_property( document_underline, "modulate", Color.TRANSPARENT, 0.5 )
	await t.finished
	
	B2_CManager.release_event_lock.emit()
	queue_free()

func _ready() -> void:
	_change_page()
	_update_page_status()
	_update_buttons()
	
	bg.modulate 					= Color.TRANSPARENT
	frame.modulate 					= Color.TRANSPARENT
	document_underline.modulate 	= Color.TRANSPARENT
	var t := create_tween()
	t.set_parallel( true )
	t.tween_property( bg, "modulate", Color.WHITE, 0.5 )
	t.tween_property( frame, "modulate", Color.WHITE, 0.5 )
	t.tween_property( document_underline, "modulate", Color.WHITE, 0.5 )
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Holster"):
		set_process( false )
		B2_Sound.play( "sn_maria_paper1" )
		_finish_reading()
		
	
func setup_title( title : String ) -> void:
	document_title = title
	
func setup_pages( pages : Array ) -> void:
	document_page = pages

func _change_page( left := false) -> void:
	B2_Sound.play( "sn_maria_paper1" )
	var dir := 1.0
	if left: dir = -1.0
	document_arrow_left.disabled 	= true
	document_arrow_right.disabled 	= true
	if page_tween: page_tween.kill()
	page_tween = create_tween()
	page_tween.set_parallel( true )
	page_tween.tween_property(document_content_lbl, "position:x", -384.0 * dir, 0.25)
	page_tween.tween_property(document_content_lbl, "modulate:a", 0.0, 0.025)
	await page_tween.finished
	
	document_title_lbl.text = Text.pr( document_title )
	document_content_lbl.text = Text.pr( document_page[ curr_page ] )
	document_content_lbl.position.x = 384.0 * dir
	document_content_lbl.modulate.a = 0.0
	
	page_tween = create_tween()
	page_tween.set_parallel( true )
	page_tween.tween_property(document_content_lbl, "position:x", 42.0, 0.25)
	page_tween.tween_property(document_content_lbl, "modulate:a", 1.0, 0.025)
	await page_tween.finished
	_update_buttons()

func _update_page_status() -> void:
	document_page_lbl.text = Text.pr( "PAGE %s/%s" % [curr_page + 1, document_page.size()] )

func _update_buttons() -> void:
	document_arrow_left.disabled = curr_page == 0
	document_arrow_right.disabled = curr_page == document_page.size() - 1

func _on_document_arrow_left_pressed() -> void:
	curr_page -= 1
	_change_page( true )
	_update_page_status()
	_update_buttons()

func _on_document_arrow_right_pressed() -> void:
	curr_page += 1
	_change_page( false )
	_update_page_status()
	_update_buttons()
