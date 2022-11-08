extends Control

func _ready():
	Global.reset_variables()
	$TryAgain.pressed.connect(
		func():
			get_tree().change_scene_to_file("res://levels/game.tscn")
	)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
