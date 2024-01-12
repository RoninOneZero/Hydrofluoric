extends Control

@export var player: Agent 
@export var navigation: Navigation

@export var camera: CameraController

var has_control := true
var camera_motion := false

var state := "move"


func _input(event):
	# Overrides.
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if event.is_action_pressed("camera_left") and !camera_motion:
		await move_camera(Vector3.LEFT)
	elif event.is_action_pressed("camera_right") and !camera_motion:
		await move_camera(Vector3.RIGHT)
	
	if !has_control:
		return
	# Contextual actions.
	if event.is_action_pressed("ui_accept") and state == "move":
		get_viewport().set_input_as_handled() # Why does this work				
		await give_move_order(3)

	if event.is_action_pressed("ui_accept") and state == "hand":
		pass

## Orders the player to move a given distance. Called with await.
func give_move_order(move_distance: int = 3) -> void:
	has_control = false
	#camera.target = navigation.control_widget
	var path := await navigation.process_movement(player.global_position, move_distance)
	player.set_path(path)
	#camera.target = player
	await player.finished_movement	
	has_control = true

# Rotates the camera pivot. Not smooth. Does not change input basis.
func move_camera(direction: Vector3) -> void:
	camera_motion = true
	var rotation_angle := 0.0

	match direction:
		Vector3.RIGHT: rotation_angle = PI / 2
		Vector3.LEFT: rotation_angle = -PI / 2

	var final_angle := camera.rotation.y + rotation_angle
	# rotate camera 90 degrees
	var tween := get_tree().create_tween()
	tween.tween_property(camera, "rotation:y", final_angle, 0.3)
	navigation.control_widget.camera_bias = final_angle
	await tween.finished
	camera_motion = false
