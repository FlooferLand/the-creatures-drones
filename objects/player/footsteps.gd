extends Node3D

# Nodes
@onready var audio: AudioStreamPlayer = $AudioPlayer
@onready var timer: Timer = $Timer
@onready var raycast: RayCast3D = $RayCast

# Signals
signal footstep()

# Constants
const WALK_TIME   := 0.5
const RUN_TIME    := 0.3
const CROUCH_TIME := 0.7

# Variables
var bus_index   := 0
var effect_eq   := 0
var effect_dist := 0
var effect_crouch_eq := 0

# Node methods
func _ready():	
	timer.wait_time = WALK_TIME
	timer.timeout.connect(
		func():
			if not Global.player.is_moving:
				return
			play_once()
			timer.start()
			emit_signal("footstep")
	)
	
	# Getting audio stuff
	bus_index   = AudioServer.get_bus_index("Footsteps")
	effect_eq   = 0
	effect_dist = 1
	effect_crouch_eq = 2

func _input(_event):
	if Input.is_action_just_pressed("sprint"):
		timer.wait_time = RUN_TIME
	elif Input.is_action_just_released("sprint"):
		timer.wait_time = WALK_TIME
	elif Input.is_action_just_pressed("crouch"):
		timer.wait_time = CROUCH_TIME
	elif Input.is_action_just_released("crouch"):
		timer.wait_time = WALK_TIME
	
# Methods
func start():
	timer.start()
	play_once()

func stop():
	timer.stop()

func play_once():
	# Forcing raycast update && safety check
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		return
	
	# Finding out the material under the player
	var collider: Node3D = raycast.get_collider()
	if not (collider.get_parent() is MeshInstance3D) or collider == null:
		return
	
	var instance: MeshInstance3D = (collider.get_parent() as MeshInstance3D)
	var material: BaseMaterial3D = instance.get_active_material(0)
	
	for key in AudioState.footsteps.keys():
		if key in material.resource_path:
			# Playing audio
			var harshness = "harsh" if Global.player.is_running else "soft"
			
			if harshness == "harsh":
				AudioServer.set_bus_effect_enabled(bus_index, effect_eq,   false)
				AudioServer.set_bus_effect_enabled(bus_index, effect_dist, true)
				AudioServer.set_bus_effect_enabled(bus_index, effect_crouch_eq, false)
			else:
				AudioServer.set_bus_effect_enabled(bus_index, effect_eq,   true)
				AudioServer.set_bus_effect_enabled(bus_index, effect_dist, false)
				AudioServer.set_bus_effect_enabled(bus_index, effect_crouch_eq, Global.player.is_crouching)
			
			var footsteps = AudioState.footsteps[key][harshness]
			AudioState.play_random(audio, footsteps)
			return
	AudioState.play_random(audio, AudioState.footsteps["other"])

