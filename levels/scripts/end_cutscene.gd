extends Node3D

# Nodes
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	anim_player.play("Main")
	anim_player.animation_finished.connect(
		func(name):
			if name != "Main":
				return
			get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	)
