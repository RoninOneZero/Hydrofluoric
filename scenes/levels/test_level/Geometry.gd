class_name GeometryController
extends Node3D

@onready var block_gridmap: GridMap = get_node("Blocks")

func get_block_list() -> Array[Node3D]:
	var new_list: Array[Node3D] = []

	for item in block_gridmap.get_meshes():
		if item is Transform3D:
			var node := Node3D.new()
			node.position = item.origin
			new_list.append(node)

	return new_list
