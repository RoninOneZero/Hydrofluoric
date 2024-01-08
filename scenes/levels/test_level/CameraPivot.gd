class_name CameraController
extends Node3D

@export var height := 10.0
@export var turn_speed := 10.0
@export var move_speed := 10.0

@export var target: Node3D : set = set_target

@onready var camera: Camera3D = get_node("Camera3D")


func _process(delta: float):
	var target_position := target.global_position + Vector3(0, height, 0)

	if target:
		global_position = global_position.move_toward(target_position, delta * move_speed)




func set_target(arg) -> void:
	target = arg
	camera.look_at(target.global_position)