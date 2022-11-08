extends RigidBody3D

# Nodes
@onready var collision := $Collision

# Node methods
func _ready():
	Global.max_belongings += 1

# Methods
func pickup():
	if Global.player.is_holding_item:
		return
	
	# Re-parenting
	collision.disabled = true
	get_parent().remove_child(self)
	Global.player.belongings.add_child(self)
	name = "Item"
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	rotation.y = PI / 2
	scale = Vector3.ONE * 0.5
	Global.player.is_holding_item = true
