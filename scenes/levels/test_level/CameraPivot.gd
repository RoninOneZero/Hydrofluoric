class_name CameraController
extends Node3D

@export var target: Node3D : set = set_target

@onready var camera: Camera3D = get_node("Camera3D")



func _process(delta):
	if target:
		camera.look_at(target.position)

func set_target(arg) -> void:
	target = arg
	reparent(target)
	position *= Vector3(0, 1, 0)
