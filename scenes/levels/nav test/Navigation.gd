class_name Navigation
extends Node

@export var block_size: int = 2

@export var control_widget: Node3D
@export var player: Node3D
var widget_state := "Idle"

var block_grid := {}
var navigation_points := {}

var astar := AStar3D.new()
var nav_marker := preload("res://scenes/levels/nav test/nav_marker.tscn")

func _ready() -> void:
	#init grid
	_initialize_block_grid()

	# init astar
	navigation_points = _initialize_astar()
	
	#DEBUG pathfind
	var valid_path := astar.get_point_path(navigation_points[Vector3(1, 3, 3)], navigation_points[Vector3(11, 3, 3)])

	for location in valid_path:
		var node = nav_marker.instantiate()
		node.position = location
		get_tree().root.add_child.call_deferred(node)

	# Parent widget to the player
	control_widget.reparent(player)
	control_widget.position = Vector3.ZERO #+ Vector3.UP * block_size 

func _input(event: InputEvent) -> void:
	pass

# add second argument for eligible blocks
## Attempts to move selector over a valid block. Reminder that the selector is one block above player.		
func move_selector(direction: Vector2) -> void:
	# Init the destination var, which lands above the player height level
	var target_destination: Vector3 = control_widget.global_position + Vector3(direction.x, 0, direction.y) * block_size
	# If a block exists on player level, fail operation
	if block_grid.has(target_destination + Vector3.DOWN * block_size):
		return
	# Ask block grid if there's a block under neath the player (2 grid slots below target)
	if block_grid.has(target_destination + Vector3.DOWN * block_size * 2):
		control_widget.global_position = target_destination # Moves widget if true

## Rewrite this fucking function
func move_player_to(location: Vector3) -> void:
	player.global_position = location
	control_widget.position = Vector3.ZERO #+ Vector3.UP * block_size




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

func deactivate_block(block: GridBlock) -> void:
	if block: block.hide_marker()

#TODO the highlight should exist on the grid layer of the space you want to get to, not the block underneath
## Activates highlight of block. Does nothing if block cannot be found.
func activate_block(block) -> void:
	if block: block.show_marker()

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


### This needs careful planning.
### Any empty space above a solid block should be added.
### Add connections that correspond to 3D space
### Verticality can come later, for now focus on single layer.

## But also they need to be connected in a gridlike manner.

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

