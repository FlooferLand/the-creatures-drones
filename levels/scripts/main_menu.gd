extends Control

# Node methods
func _ready():
	Global.reset_variables()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Main/Info.meta_clicked.connect(
		func(link):
			OS.shell_open(link)
	)
	$Main/Buttons/Start.pressed.connect(
		func():
			$Main.visible = false
			$Info.visible = true
	)
	$Main/Buttons/Quit.pressed.connect(get_tree().quit)
