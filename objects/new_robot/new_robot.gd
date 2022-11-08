extends Node3D

# Nodes
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var angy_audio: AudioStreamPlayer3D   = $AngyAudio

# Variables
var id := 0

# Node methods
func _ready():
	$Robot/Model/AnimationPlayer.play("Walk")
	anim_player.play("Main")
	anim_player.animation_finished.connect(
		func(anim_name):
			if anim_name != "Main":
				return
			$Robot.queue_free()
	)

func grab_item():
	if id == 3:
		Global.the_creature.start()
	for item in Global.enemy_spawner.get_node("../Belongings").get_children():
		if item.name == str(id):
			Global.grabbed_belongings -= 1
			item.queue_free()
			return
	# Item not found:
	angy_audio.play()
