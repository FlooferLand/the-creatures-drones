extends Node
###########################
# Global Variable Storage #
###########################

# Nodes
var player: CharacterBody3D = null
var ui:     Control         = null
var loading_ui: Control     = null
var enemy_spawner: Node3D   = null
var the_creature: Node3D    = null

# Variables
var max_belongings := 0
var grabbed_belongings := 0
var time := 60.0
var times_oogaboogad := 0
var fullscreen := false

# Useful stuff
func reset_variables():
	max_belongings = 0
	grabbed_belongings = 0
	time = 60.0
	times_oogaboogad = 0

func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if not fullscreen:
			get_tree().root.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			fullscreen = true
		else:
			get_tree().root.mode = Window.MODE_WINDOWED
			fullscreen = false
