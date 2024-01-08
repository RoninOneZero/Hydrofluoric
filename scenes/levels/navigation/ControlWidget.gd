class_name ControlWidget
extends Node3D

var block_size = 2
var valid_points: PackedVector3Array = []

var camera_bias := 0.0

signal location_selected

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if valid_points.is_empty():
		return

	# Process directional movement
	if event.is_action_pressed("ui_up"):
		_move_cursor(Vector3.FORWARD.rotated(Vector3.UP, camera_bias))
	if event.is_action_pressed("ui_down"):
		_move_cursor(Vector3.BACK.rotated(Vector3.UP, camera_bias))
	if event.is_action_pressed("ui_left"):
		_move_cursor(Vector3.LEFT.rotated(Vector3.UP, camera_bias))
	if event.is_action_pressed("ui_right"):
		_move_cursor(Vector3.RIGHT.rotated(Vector3.UP, camera_bias))
	# Confirm movement
	if event.is_action_pressed("ui_accept"):
		_confirm_location()


func get_destination(origin: Vector3, points: PackedVector3Array) -> void:
	global_position = origin
	valid_points = points
	show()


func _move_cursor(direction: Vector3) -> void:
	direction = direction.round()
	#Vector3(0, 0.5, 0)
	var target = global_position + (block_size * direction)

	var upper = target + Vector3(0, +0.5, 0)
	var lower = target + Vector3(0, -0.5, 0)
	var upper_high = target + Vector3(0, +1.0, 0)
	var lower_low = target + Vector3(0, -1.0, 0)

	# Check upper high
	if valid_points.has(upper_high):
		global_position = upper_high
		return


	# Check upper
	if valid_points.has(upper):
		global_position = upper
		return

	# Check lower
	if valid_points.has(lower):
		global_position = lower
		return

	# Check lower
	if valid_points.has(lower_low):
		global_position = lower_low
		return

	# Check same height
	if valid_points.has(target):
		global_position = target
		return

func _confirm_location() -> void:
	valid_points.clear()
	hide()
	emit_signal("location_selected")
