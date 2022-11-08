extends Node3D

# Nodes
@onready var light: OmniLight3D = $Offset/Light
@onready var offset: Node3D = $Offset

# Variables
var max_light_energy := 0.0
var turned_on := true

# Node methods
func _ready():
	max_light_energy = light.light_energy
	# light.light_energy = 0.0

func _process(delta):
	var dest: float = (max_light_energy if turned_on else 0.0)
	light.light_energy = lerp(light.light_energy, dest, 5 * delta)
	
	var pos_dest: float = (0.0 if turned_on else -0.4)
	offset.position.z = lerp(offset.position.z, pos_dest * 0.8, 3 * delta)
	offset.position.y = lerp(offset.position.y, pos_dest, 5 * delta)
	
	# Model disappearing
	if not turned_on and int(rad_to_deg(offset.position.y)) == int(rad_to_deg(pos_dest)):
		offset.visible = false
	else:
		offset.visible = true

func _input(event):
	if event is InputEventAction or event is InputEventKey:
		if Input.is_action_just_pressed("toggle_lantern"):
			turned_on = !turned_on
