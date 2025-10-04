extends Node2D

@export_range(25, 180) var length := 80
@export_enum("Clockwise", "C-Clockwise") var direction := 0
@export_range(4, 12) var boo_amount := 10
@export var spread_boos := false

const MAX_BOOS = 12
const BOO_BUDDY = preload("res://Scenes/Prefabs/Entities/Enemies/BooBuddy.tscn")

func _ready() -> void:
	for i in MAX_BOOS:
		var boo_buddy = BOO_BUDDY.instantiate()
		$Boos.add_child(boo_buddy)

func _physics_process(delta: float) -> void:
	%RotationJoint.global_rotation_degrees = wrap(%RotationJoint.global_rotation_degrees + (45 * [1, -1][direction]) * delta, 0, 360)
	for i in $Boos.get_children():
		if (i is BooBuddy):
			i.get_node("Sprite").scale.x = sign(get_tree().get_first_node_in_group("Players").global_position.x + 1 - i.global_position.x)

func flag_die() -> void:
	queue_free()
