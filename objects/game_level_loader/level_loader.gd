extends Panel

func _ready():
	visible = false
	if Global.ui != null:
		Global.ui.visible = true

#func _ready():
#	$Timer.timeout.connect(
#		func():
#			get_tree().paused = false
#			visible = false
#			if Global.ui != null:
#				Global.ui.visible = true
#	)
