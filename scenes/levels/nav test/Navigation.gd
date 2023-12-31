class_name Navigation
extends Node


@export var control_widget: ControlWidget
@export var player: Node3D

var block_size: int = 2
var block_grid := {}
var navigation_points := {}

var astar := AStar3D.new()
var nav_marker := preload("res://scenes/levels/nav test/nav_marker.tscn")

var has_control: bool = false
signal control_returned

func _ready() -> void:
	control_widget.hide()
	control_widget.block_size = block_size

	#init grid
	_initialize_block_grid()

	# init astar
	navigation_points = _initialize_astar()

	
	

## Return a path based on a location and distance.
func process_movement(origin: Vector3, distance: int) -> PackedVector3Array:
	# Get eligible points
	var active_points := get_points_in_range(origin, distance)
	# Highlight points
	for point in active_points:
		var node = nav_marker.instantiate()
		node.position = point
		get_tree().root.add_child(node)
	# Get a location from the widget
	control_widget.get_destination(origin, active_points)
	await control_widget.location_selected
	var destination = control_widget.position
	# Remove any markers
	get_tree().call_group("Markers", "queue_free")	

	return astar.get_point_path(navigation_points[origin], navigation_points[destination])


## Return a list of blocks adjacent to given Node3D
func get_blocks_in_range(location: Node3D) -> Array[Node3D]:
	var origin_block: Node3D = neighbor_below(location)
	var list: Array[Node3D] = [origin_block]

	if neighbor_north(origin_block): list.append(neighbor_north(origin_block))
	if neighbor_south(origin_block): list.append(neighbor_south(origin_block))
	if neighbor_east(origin_block): list.append(neighbor_east(origin_block))
	if neighbor_west(origin_block): list.append(neighbor_west(origin_block))

	return list



## Initializes block_grid
func _initialize_block_grid() -> void:
	var block_list = get_tree().get_nodes_in_group("Blocks")
	for block in block_list:
		block_grid[block.position] = block

# func deactivate_block(block: GridBlock) -> void:
# 	if block: block.hide_marker()

# ## Activates highlight of block. Does nothing if block cannot be found.
# func activate_block(block) -> void:
# 	if block: block.show_marker()

## Returns the block north (-z) of given block. If no block exists, returns null.
func neighbor_north(block: Node3D):
	var target_location := block.position + Vector3.FORWARD * block_size
	return block_grid[target_location] if block_grid.has(target_location) else null

## Returns the block south (+z) of given block. If no block exists, returns null.
func neighbor_south(block: Node3D):
	var target_location := block.position + Vector3.BACK * block_size
	return block_grid[target_location] if block_grid.has(target_location) else null

## Returns the block east (+x) of given block. If no block exists, returns null.
func neighbor_east(block: Node3D):
	var target_location := block.position + Vector3.RIGHT * block_size
	return block_grid[target_location] if block_grid.has(target_location) else null


## Returns the block west (-x) of given block. If no block exists, returns null.
func neighbor_west(block: Node3D):
	var target_location := block.position + Vector3.LEFT * block_size
	return block_grid[target_location] if block_grid.has(target_location) else null

## Returns the block below (-y) of given block. If no block exists, returns null.
func neighbor_below(block: Node3D):
	var target_location := block.position + Vector3.DOWN * block_size
	return block_grid[target_location] if block_grid.has(target_location) else null

## Returns the block above (+y) of given block. If no block exists, returns null.
func neighbor_above(block: Node3D):
	var target_location := block.position + Vector3.UP * block_size
	return block_grid[target_location] if block_grid.has(target_location) else null

# could be more optimal
## Return a list of points that can be walked to from the origin point within given distance.
func get_points_in_range(location: Vector3, distance: int) -> PackedVector3Array:
	var point_list: PackedVector3Array = []
	# Poll points to see if navigation to location is possible
	for point in navigation_points.keys():
		var sample_path: = astar.get_point_path(navigation_points[point], navigation_points[location])
		# If the path exists, test its size.
		if !sample_path.is_empty():
			if sample_path.size() <= distance + 1:
				# Add only unique points to the point_list
				for item in sample_path:
					if !point_list.has(item):
						point_list.append(item)

	return point_list

## Generates nav points for A* pathfinding
func _initialize_astar() -> Dictionary:
	# Store valid locations assigned to their ID in the nav
	var valid_points := {}

	# Add valid locations to the nav
	for location in block_grid:
		# Find out of there's an empty space above the block
		if !neighbor_above(block_grid[location]): # If yes, add the open space to the nav
			var point_id: int = astar.get_available_point_id()
			valid_points[location + Vector3.UP * block_size] = point_id
			astar.add_point(point_id, location + Vector3.UP * block_size)

	# Find valid connections
	for location in valid_points:
		var north: Vector3 = location + block_size * Vector3.FORWARD
		var south: Vector3 = location + block_size * Vector3.BACK
		var east: Vector3 = location + block_size * Vector3.RIGHT
		var west: Vector3 = location + block_size * Vector3.LEFT
		# validate adjacent candidates and then connect them
		if valid_points.has(north): astar.connect_points(valid_points[location], valid_points[north])
		if valid_points.has(south): astar.connect_points(valid_points[location], valid_points[south])
		if valid_points.has(east): astar.connect_points(valid_points[location], valid_points[east])
		if valid_points.has(west): astar.connect_points(valid_points[location], valid_points[west])

	return valid_points

