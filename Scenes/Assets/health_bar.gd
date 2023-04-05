extends MeshInstance3D

@export var parent: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	if parent != null:
		parent.set_health.connect(_on_set_health)

func _on_set_health(percentage: float):
	print("set_health")
	mesh.height = percentage
