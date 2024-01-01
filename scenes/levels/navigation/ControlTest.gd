extends Control

@export var player: Agent 
@export var navigation: Navigation

var has_control := true

func _input(event):
	if !has_control:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled() # Why does this work
		has_control = false		
		var path := await navigation.process_movement(player.global_position, 3)
		player.set_path(path)
		await player.finished_movement
		has_control = true
