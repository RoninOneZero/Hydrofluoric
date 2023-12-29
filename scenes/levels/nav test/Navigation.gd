class_name Navigation
extends Node

@export var block_size: int = 2

@export var control_widget: Node3D
@export var player: Node3D
var widget_state := "Idle"

var block_grid := {}



func _ready() -> void:
	#init grid
	_initialize_block_grid()

	# Set control widget above player's head
	control_widget.reparent(player)
	control_widget.position = Vector3.ZERO + Vector3.UP * block_size 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		match widget_state:
			"Idle":
					var blocks_in_range := get_blocks_in_range(player) # Could use this for control_widget
					for block in blocks_in_range:
						activate_block(block)
					widget_state = "Selection"

			"Selection":
					move_player_to(control_widget.global_position + Vector3.DOWN * block_size)
					get_tree().call_group("Blocks", "hide_marker")
					widget_state = "Idle"
		
	if event.is_action_pressed("ui_up") and widget_state == "Selection":
		move_selector(Vector2.UP)
	if event.is_action_pressed("ui_down") and widget_state == "Selection":
		move_selector(Vector2.DOWN)
	if event.is_action_pressed("ui_left") and widget_state == "Selection":
		move_selector(Vector2.LEFT)
	if event.is_action_pressed("ui_right") and widget_state == "Selection":
		move_selector(Vector2.RIGHT)

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
	control_widget.position = Vector3.ZERO + Vector3.UP * block_size




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

## Returns the block below (-x) of given block. If no block exists, returns null.
func neighbor_below(block: Node3D):
	var target_location := block.position + Vector3.DOWN * block_size
	return block_grid[target_location] if block_grid.has(target_location) else null
