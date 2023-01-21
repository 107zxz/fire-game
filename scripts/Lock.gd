extends Interactable

@export var key: String

func _ready():
	item_meta.type = "lock"
	item_meta.key = key
	
	
func _input_event(_camera, event, _position, _normal, _shape_idx):
	
	if not visible:
		return
	
	if event is InputEventMouseButton and event.pressed:
		
		if get_node("/root/Game").active_item != key:
			return
		
		get_node("/root/Game").collect_item(self)
		
		hide()
		
		emit_signal("interacted")
