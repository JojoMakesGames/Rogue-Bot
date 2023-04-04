extends Control

@onready var destruction_counter: Label = $DestructionCounter


# Called when the node enters the scene tree for the first time.
func _ready():
	ChaosTracker.object_destroyed.connect(_on_object_destroyed)

func _on_object_destroyed(object: Destroyable):
	var counter = int(destruction_counter.text)
	counter += object.POINTS
	destruction_counter.text = str(counter)
	
