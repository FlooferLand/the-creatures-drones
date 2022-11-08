extends CharacterBody3D

# Nodes
@onready var agent: NavigationAgent3D = $NavAgent
@onready var model: Node3D = $Model
@onready var anim_player: AnimationPlayer = $Model/AnimationPlayer
@onready var close_prox: Area3D = $CloseProximity

# Constants
const SPEED := 2

# Variables
var player_is_close := false

# Node methods
func _ready():
	agent.set_target_location(Global.player.global_position)
	anim_player.play("Walk")

func _physics_process(_delta):
	if agent.is_navigation_finished():
		print("nav finished")
		agent.set_target_location(Global.player.global_position)
		return
	var target_pos = agent.get_next_location()
	var direction  = global_position.direction_to(target_pos)
	velocity = direction * SPEED
	print(target_pos)
	
	move_and_slide()
