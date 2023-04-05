extends Control

@onready var destruction_counter: Label = $DestructionCounter
@onready var sprite: Sprite2D = $health/Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ChaosTracker.object_destroyed.connect(_on_object_destroyed)
	ChaosTracker.player_hack.connect(_on_hack)

func _on_object_destroyed(object: Node3D):
	var counter = int(destruction_counter.text)
	counter += object.POINTS
	destruction_counter.text = str(counter)
	
func _on_hack(player: Player, hacked_instance_id: int):
	sprite.texture = instance_from_id(hacked_instance_id).texture
	
