extends Interactable

@export_multiline var note_text = "TODO_FILL_NOTE"

func _ready():
	item_meta.type = "note"
	item_meta.text = note_text

#func _input_event(_camera, event, _position, _normal, _shape_idx):
#
#	if not visible:
#		return
#
#	if event is InputEventMouseButton and event.pressed:
#		get_node("/root/Game").collect_item(self)
##		get_node("/root/Game").connect("exited_note", _note_closed_callback)
#
#		hide()
#
#func _note_closed_callback():
#	get_node("/root/Game").disconnect("exited_note", _note_closed_callback)
#	show()
