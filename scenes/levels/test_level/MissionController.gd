class_name MissionController
extends Node


@export var navigation: Navigation
@export var geometry: GeometryController

func _ready() -> void:
	# Initialize components
	var block_list = geometry.get_block_list()
	var ramp_list = geometry.get_ramp_list()

	for block in block_list:
		navigation.add_child(block)

	for ramp in ramp_list:
		navigation.add_child(ramp)

	
	navigation.initialize_navigation(block_list, ramp_list)

