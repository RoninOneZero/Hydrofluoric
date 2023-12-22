class_name MetalDeck
extends Resource

## The abstract list of cards that were used to construct the deck
@export var list: Array[MetalCardData] = []
var list_size: int : get = _get_list_size

## The cards as a physical stack of cards that can be drawn from and shuffled
var pile: Array
var size: int : get = _get_size

signal shuffled
signal card_drawn
signal deck_emptied


## Generate a new unshuffled pile from deck list for use in game
func create_pile() -> void:
    # Needs a function that creates new instances of the cards
    # Note that duplicate does not make copies of the cards no matter what
	pile = list.duplicate()


## Remove and return a card from the top of the pile. Recommend use of draw() instead.
func draw_card():
	# Error handling
	if pile == null or pile.is_empty():
		emit_signal("deck_emptied")
		return null
	
	emit_signal("card_drawn")
	return pile.pop_front()

## Returns either a single card or an array of cards. Returns null on error.
func draw(amount: int = 1):
	# Error handling
	if amount <= 0:
		return null
	elif amount == 1:
		return draw_card()

	var stack := []
	for n in amount:
		stack.append(draw_card())
	return stack

## shuffles the pile.
func shuffle() -> void:
	if pile == null or pile.is_empty():
		return

	pile.shuffle()
	emit_signal("shuffled")

func _get_list_size() -> int:
	return list.size()

func _get_size() -> int:
	return pile.size()