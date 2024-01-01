extends Control

@export var player: Agent 
@export var navigation: Navigation

var has_control := true

func _input(event):
	# Overrides.
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if !has_control:
		return
	# Contextual actions.
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled() # Why does this work
		has_control = false		
		await give_move_order(3)
		has_control = true

## Orders the player to move a given distance. Called with await.
func give_move_order(move_distance: int = 3) -> void:
	var path := await navigation.process_movement(player.global_position, move_distance)
	player.set_path(path)
	await player.finished_movement