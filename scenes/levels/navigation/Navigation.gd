class_name Navigation
extends Node

@onready var control_widget: ControlWidget = get_node("ControlWidget")

var spawn_point := Vector3.ZERO

var block_size: int = 2
var nav_markers: Array[NavPoint] = []
var nav_points: PackedVector3Array = []

var astar := AStar3D.new()
var nav_marker := preload("nav_marker.tscn")

var has_control: bool = false
signal control_returned

func _ready() -> void:
	control_widget.hide()
	control_widget.block_size = block_size


	
func initialize_navigation() -> void:
	_initialize_astar()


## Return a path based on a location and distance.
func process_movement(origin: Vector3, distance: int) -> PackedVector3Array:
	# Get eligible points
	var active_points := get_points_in_range(origin, distance)


	# Highlight points
	for point in active_points:
		nav_markers[nav_points.find(point)].highlight()
	# Get a location from the widget
	control_widget.get_destination(origin, active_points)
	await control_widget.location_selected
	var destination = control_widget.position

	# Remove any markers
	get_tree().call_group("NavPoints", "highlight_off")

	return astar.get_point_path(nav_points.find(origin), nav_points.find(destination))


## Return a list of blocks adjacent to given Node3D
# func get_blocks_in_range(location: Node3D) -> Array[Node3D]:
# 	var origin_block: Node3D = neighbor_below(location)
# 	var list: Array[Node3D] = [origin_block]

# 	if neighbor_north(origin_block): list.append(neighbor_north(origin_block))
# 	if neighbor_south(origin_block): list.append(neighbor_south(origin_block))
# 	if neighbor_east(origin_block): list.append(neighbor_east(origin_block))
# 	if neighbor_west(origin_block): list.append(neighbor_west(origin_block))

# 	return list



## Initializes block_grid. 
# func _initialize_block_grid(blocks: Array[Node3D]) -> void:
# 	for block in blocks:
# 		block_grid[block.global_position] = block


# ## Returns the block north (-z) of given block. If no block exists, returns null.
# func neighbor_north(block: Node3D):
# 	var target_location := block.position + Vector3.FORWARD * block_size
# 	return block_grid[target_location] if block_grid.has(target_location) else null

# ## Returns the block south (+z) of given block. If no block exists, returns null.
# func neighbor_south(block: Node3D):
# 	var target_location := block.position + Vector3.BACK * block_size
# 	return block_grid[target_location] if block_grid.has(target_location) else null

# ## Returns the block east (+x) of given block. If no block exists, returns null.
# func neighbor_east(block: Node3D):
# 	var target_location := block.position + Vector3.RIGHT * block_size
# 	return block_grid[target_location] if block_grid.has(target_location) else null


# ## Returns the block west (-x) of given block. If no block exists, returns null.
# func neighbor_west(block: Node3D):
# 	var target_location := block.position + Vector3.LEFT * block_size
# 	return block_grid[target_location] if block_grid.has(target_location) else null

# ## Returns the block below (-y) of given block. If no block exists, returns null.
# func neighbor_below(block: Node3D):
# 	var target_location := block.position + Vector3.DOWN * block_size
# 	return block_grid[target_location] if block_grid.has(target_location) else null

# ## Returns the block above (+y) of given block. If no block exists, returns null.
# func neighbor_above(block: Node3D):
# 	var target_location := block.position + Vector3.UP * block_size
# 	return block_grid[target_location] if block_grid.has(target_location) else null

# could be more optimal
## Return a list of points that can be walked to from the origin point within given distance.
func get_points_in_range(location: Vector3, distance: int) -> PackedVector3Array:
	var point_list: PackedVector3Array = []
	# Poll points to see if navigation to location is possible
	for point in nav_points:
		var sample_path: = astar.get_point_path(nav_points.find(point), nav_points.find(location))
		# If the path exists, test its size.
		if !sample_path.is_empty():
			if sample_path.size() <= distance + 1:
				# Add only unique points to the point_list
				for item in sample_path:
					if !point_list.has(item):
						point_list.append(item)

	return point_list

## Generates nav points for A* pathfinding
func _initialize_astar():
	# Get navigation nodes
	nav_markers.assign(get_tree().get_nodes_in_group("NavPoints"))

	nav_points.resize(nav_markers.size())

	for node in nav_markers:
		# Check special flags
		if node.spawn_point: spawn_point = node.global_position
		# Record node positions and locations in astar
		var index = astar.get_available_point_id()
		nav_points[index] = node.global_position
		astar.add_point(index, nav_points[index])
		# Record connections
		var connections = node.get_connections()
		# Check if connections has points to connect
		# If so, check if positions in exists in astar
		# If so, connect the points
		if !connections.is_empty():
			for position in connections:
				if nav_points.has(position):
					astar.connect_points(index, nav_points.find(position))



