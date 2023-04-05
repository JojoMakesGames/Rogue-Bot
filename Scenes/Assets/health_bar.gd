extends MeshInstance3D

@export var parent: Node3D

func _on_set_health(percentage: float):
	mesh.height = percentage

