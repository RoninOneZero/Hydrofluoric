class_name MetalHand
extends Control

const MARGIN := 200

@export var limit: int

var contents: Array[MetalCard] = [] : set = set_contents

## Introduce a card to hand. Assumes validity.
func add_card(card: MetalCard) -> void:
	if is_full():
		return
	
	contents.append(card)
	add_child(card)
	# Minify card
	card.scale = Vector2(0.35, 0.35)
	_resize_hand()

## Returns the card at given index and removes it from hand.
func take_card(index: int) -> MetalCard:
	if contents.size() - 1 < 0:
		return
	var orphan = contents[index]
	contents.remove_at(index)
	_resize_hand()
	remove_child(orphan)
	return orphan


## Adjusts visuals to show all cards in hand
func _resize_hand() -> void:
	var i := 0 #Iterator
	for card in contents:
		card.position.x = i * MARGIN
		i += 1

## Check if current hand is full.
func is_full() -> bool:
	return contents.size() == limit

## Disallow contents to exceed set hand limit
func set_contents(value: Array) -> void:
	if value.size() > limit:
		return
	else:
		contents = value

