
class_name Agent
extends Node3D

@export var movement_speed: float = 4

var start_movement := false

signal started_movement
signal point_reached
signal finished_movement

var _path: PackedVector3Array = [] : set = set_path

var facing_direction := Vector3.FORWARD

func _physics_process(delta: float) -> void:
	if start_movement:
		move_along_path(position, delta)

func move_along_path(origin: Vector3, delta: float) -> void:
	# Check if agent is at the next location
	if !position == _path[0]:
		position = origin.move_toward(_path[0], delta * movement_speed)
	else:
		var checkpoint = _path[0]
		_path.remove_at(0)
		emit_signal("point_reached")
		if _path.is_empty(): # If path is empty, finish operation
			emit_signal("finished_movement")
			start_movement = false
			return
		else: # reset start point then loop back
			move_along_path(checkpoint, delta)

func set_path(arg: PackedVector3Array) -> void:
	emit_signal("started_movement")
	_path = arg
	start_movement = true
