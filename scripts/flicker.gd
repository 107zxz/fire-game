extends MeshInstance3D

@export var max_size: float
@export var variance: float
@export var period: float

var timer: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	
	timer += delta
	
	var dim: float = max_size - sin(timer * 1/period) * variance
	
	scale = Vector3(dim, dim, dim)
