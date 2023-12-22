class_name CardSelector
extends Control

@export var card_template: PackedScene

signal hand_full
# Card slots
var cards_in_hand: Array = [null, null, null, null, null, null]

func _ready() -> void:
	$CardSlot1.grab_focus()

func add_card(card: MetalCardData) -> void:
	if is_full():
		return
	var index = cards_in_hand.find(null)

	var new_card = CardPrinter.instance_card(card_template, card)
	cards_in_hand[index] = new_card
	var slot = get_child(index)
	slot.add_child(new_card)

func is_full() -> bool:
	var status = cards_in_hand.find(null) < 0
	if status == true:
		emit_signal("hand_full")
	return status