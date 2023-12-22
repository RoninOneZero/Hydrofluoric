extends Node2D

@export var blank_card: PackedScene
@export var card_data: MetalCard

func _ready() -> void:
	if blank_card and card_data:
		$Marker2D.add_child(instance_card(card_data))


func instance_card(data: MetalCard) -> Node:
	var card: BlankCard = blank_card.instantiate()
	card.inscribe_card(data)
	return card
