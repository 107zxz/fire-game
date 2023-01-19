class_name Interactable

extends StaticBody3D

@export var icon: CompressedTexture2D

@onready var item_meta = {
	"icon": icon,
	"type": "generic"
}

var normMat = preload("res://materials/orangeStripeSpaced1.tres")
var hoverMat = preload("res://materials/OrangeHover.tres")

func _mouse_enter():
	$NMesh.set_surface_override_material(0, hoverMat)

func _mouse_exit():
	$NMesh.set_surface_override_material(0, normMat)
	
func _input_event(_camera, event, _position, _normal, _shape_idx):
	
	if not visible:
		return
	
	if event is InputEventMouseButton and event.pressed:
		get_node("/root/Game").collect_item(self)
		
		hide()
