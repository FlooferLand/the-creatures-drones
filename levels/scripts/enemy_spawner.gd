extends Node3D

# Packed Scenes
@onready var Robot := preload("res://objects/new_robot/new_robot.tscn")

# Nodes
@onready var timer: Timer = $Timer

# Variables
var locations: Array[Vector3] = []
var cleared:   Array[Vector3] = []
var enemies:   Array[Node3D]  = []
var count := 0

# Node methods
func _ready():
	Global.enemy_spawner = self
	timer.timeout.connect(spawn_next)
	for marker in $Locations.get_children():
		locations.append(marker.global_position)
	spawn_next()

func spawn_next():
	if len(locations) == 0:
		print("Can't spawn!")
		return
	var pos: Vector3 = locations[0]
	cleared.append(pos)
	locations.remove_at(0)
	
	var robot = Robot.instantiate()
	robot.id = count
	get_node("Locations/" + str(count)).add_child(robot)
	enemies.append(robot)
	count += 1
