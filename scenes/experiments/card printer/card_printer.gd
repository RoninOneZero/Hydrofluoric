extends Node2D

@export var blank_card: PackedScene
@export var card_data: MetalCardData = MetalCardData.new()

func _ready() -> void:
	if blank_card:
		display_card(card_data)
	else:
		print("Card form or data not found.")


func display_card(data: MetalCardData) -> void:
	var marker = $Marker2D
	marker.add_child(instance_card(data))

func instance_card(data: MetalCardData) -> Node:
	var card: MetalCard = blank_card.instantiate()
	card.inscribe_card(data)
	return card
