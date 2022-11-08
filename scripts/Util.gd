extends Node

# General utility functions

func load_level(path: NodePath):
	pass

func player_get_usable() -> Dictionary:
	#Global.player.interact_ray.force_raycast_update()
	var collider: Node3D = Global.player.interact_ray.get_collider()
	if Global.player.interact_ray.is_colliding() and is_instance_valid(collider):
		var node: Node3D = Util.is_interactable(collider)
		if node != null:
			return { "type": "interactable", "object": node }
		
		node = Util.is_pickup(collider)
		if node != null:
			return { "type": "pickup", "object": node }
		
		node = Util.is_enemy(collider)
		if node != null:
			return { "type": "enemy", "object": node }
		
		node = Util.is_car(collider)
		if node != null:
			return { "type": "car", "object": node }
	return { "type": null, "object": null }

func is_interactable(object: Node3D) -> Node3D:
	return recursive_group_check(object, "interactable")

func is_pickup(object: Node3D) -> Node3D:
	return recursive_group_check(object, "pickup")

func is_enemy(object: Node3D) -> Node3D:
	return recursive_group_check(object, "enemy")

func is_car(object: Node3D) -> Node3D:
	return recursive_group_check(object, "car")

func recursive_group_check(object: Node3D, group: String) -> Node3D:
	if not is_instance_valid(object):
		return null
	
	if object.is_in_group(group):
		return object
	else:
		var node: Node3D = object
		while node.get_parent() is Node3D:
			node = node.get_parent()
			if node.is_in_group(group):
				return node
	return null

