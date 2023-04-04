extends VehicleBody3D

var base_color: Color
var input_direction: Vector3
var player: Player
@export var texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ChaosTracker.player_hack.connect(_on_player_hack)
	ChaosTracker.player_direction.connect(_on_direction)
	ChaosTracker.looking_direction.connect(_on_looking_direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player:
		steering = Input.get_axis("right", "left") * 0.8
		engine_force = Input.get_axis("down", "up") * 100
	
func _on_player_hack(new_player: Player, hacked_instance_id: int):
	if hacked_instance_id == get_instance_id():
		player = new_player
	else:
		player = null

func _on_direction(direction: Vector3):
	input_direction = direction
	
func _on_looking_direction(_direction: Vector3):
	pass
