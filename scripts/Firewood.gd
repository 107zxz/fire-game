extends Interactable

@export var target_radius: float

func _ready():
	item_meta.type = "fuel"
	item_meta.radius = target_radius
