extends Node3D

const DoorState = {
	Closed  = 0,
	Open    = 1,
	Closing = 2,
	Opening = 3
}

# Nodes
@onready var door: Node3D = $Door
@onready var audio: AudioStreamPlayer3D = $AudioPlayer

# Variables
@onready var door_state := DoorState.Closed
var behind_player := false

# Node methods
func _physics_process(delta):
	if door_state == DoorState.Open or door_state == DoorState.Closed:
		return
	
	# I do not know how the fuck any of this works, but it works so i cannot complain
	
	var angle: int = (80 if not behind_player else -80) if door_state == DoorState.Opening else 0
	door.rotation.y = lerp_angle(door.rotation.y, deg_to_rad(angle), 12.0 * delta)
	
	if rad_to_deg(door.rotation.y) >= angle - 1 and rad_to_deg(door.rotation.y) <= angle + 1:
		door.rotation.y = deg_to_rad(angle)
		if door_state == DoorState.Opening:
			door_state = DoorState.Open
		elif door_state == DoorState.Closing:
			door_state = DoorState.Closed
			AudioState.play_random(audio, AudioState.door["close"])

# Methods
func interact():
	# Checking if the player is in front, or behind the door (https://godotengine.org/qa/9970/how-do-tell-if-an-object-is-in-front-or-behind-another-object-in)
	var vector = global_transform.basis.x
	var relative_pos = Global.player.global_transform.origin - global_transform.origin
	var dot = vector.dot(relative_pos)
	behind_player = (true if dot < 0 else false)
	
	# Switching states
	if door_state == DoorState.Closed:
		door_state = DoorState.Opening
		AudioState.play_random(audio, AudioState.door["open"])
	elif door_state == DoorState.Open:
		door_state = DoorState.Closing
	
