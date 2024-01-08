extends Control

@export var player: Agent 
@export var navigation: Navigation

@export var camera: CameraController

var has_control := true

func _input(event):
	# Overrides.
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if event.is_action_pressed("camera_left"):
		move_camera(Vector3.LEFT)
	elif event.is_action_pressed("camera_right"):
		move_camera(Vector3.RIGHT)
	
	if !has_control:
		return
	# Contextual actions.
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled() # Why does this work				
		await give_move_order(3)

## Orders the player to move a given distance. Called with await.
func give_move_order(move_distance: int = 3) -> void:
	has_control = false
	camera.target = navigation.control_widget
	var path := await navigation.process_movement(player.global_position, move_distance)
	player.set_path(path)
	camera.target = player
	await player.finished_movement	
	has_control = true

# Rotates the camera pivot. Not smooth. Does not change input basis.
func move_camera(direction: Vector3) -> void:
	var rotatation_angle := 0.0

	match direction:
		Vector3.RIGHT: rotatation_angle = PI / 2
		Vector3.LEFT: rotatation_angle = -PI / 2

	# rotate camera 90 degrees
	camera.rotate(Vector3.UP, rotatation_angle)
	navigation.control_widget.camera_bias = camera.rotation.y
