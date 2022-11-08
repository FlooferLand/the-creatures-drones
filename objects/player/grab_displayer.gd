extends Panel

func _process(_delta):
	$Count.text = "%s out of %s" % [Global.grabbed_belongings, Global.max_belongings]
