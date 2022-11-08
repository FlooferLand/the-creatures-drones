extends StaticBody3D

# Methods
func store_item(item: Node3D):
	Global.grabbed_belongings += 1
	if Global.enemy_spawner.count == Global.max_belongings or Global.grabbed_belongings == Global.max_belongings:
		get_tree().change_scene_to_file("res://levels/end_cutscene.tscn")
	item.queue_free()
