### All this shit is broken

class_name Agent
extends CharacterBody3D

@export var move_speed := 2.5

var facing := Vector3.FORWARD

signal point_reached
signal finished_movement

var destination = null

func _physics_process(_delta: float) -> void:
	if destination != null:
		velocity = global_position.direction_to(destination) * move_speed
		if global_position.distance_to(destination) <= 1:
			destination = null
			emit_signal("point_reached")
	
	move_and_slide()

## Move pawn through a given path
func move_on_path(path: PackedVector3Array) -> void:
	for point in path:
		destination = point
		await point_reached
	
	print("bop")
	
	emit_signal("finished_movement")
