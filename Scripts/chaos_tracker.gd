extends Node

var total_destruction: int = 0

signal object_destroyed(object: Destroyable)

func _ready():
	object_destroyed.connect(_on_object_destroyed)

func _on_object_destroyed(object: Destroyable):
	print_debug(object)
