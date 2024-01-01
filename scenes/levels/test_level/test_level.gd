class_name MissionController
extends Node


@export var navigation: Navigation
@export var geometry: GeometryController

func _ready() -> void:
	var block_list = geometry.get_block_list()

	for block in block_list:
		add_child(block)

	navigation.initialize_navigation(block_list)

