class_name ControlWidget
extends Node3D

var block_size = 2
var valid_points: PackedVector3Array = []

signal location_selected

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if valid_points.is_empty():
		return
	# Process directional movement
	if event.is_action_pressed("ui_up"):
		_move_cursor(Vector3.FORWARD)
	if event.is_action_pressed("ui_down"):
		_move_cursor(Vector3.BACK)
	if event.is_action_pressed("ui_left"):
		_move_cursor(Vector3.LEFT)
	if event.is_action_pressed("ui_right"):
		_move_cursor(Vector3.RIGHT)
	# Confirm movement
	if event.is_action_pressed("ui_accept"):
		_confirm_location()


func get_destination(origin: Vector3, points: PackedVector3Array) -> void:
	global_position = origin
	valid_points = points
	show()


func _move_cursor(direction: Vector3) -> void:
	if valid_points.has(global_position + block_size * direction):
		global_position += block_size * direction

func _confirm_location() -> void:
	valid_points.clear()
	hide()
	emit_signal("location_selected")
