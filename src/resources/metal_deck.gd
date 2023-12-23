class_name MetalDeck
extends Resource

## User given name for deck.
@export var name: String = "My Deck"

## The catalogue from which the deck was created.
@export var catalogue: CardCatalogue

## List of CardID's that create the deck.
@export var list: Array[int] = []
var list_size: int : get = _get_list_size


## The cards as a physical stack of cards that can be drawn from and shuffled
var pile: Array
var size: int : get = _get_size

signal shuffled
signal card_drawn
signal deck_emptied

## Generate a new unshuffled pile from deck list for use in game
func create_pile() -> void:
	for index in list:
		pile.append(catalogue.get_card(index))



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

func is_empty() -> bool:
	return pile.is_empty()

func _get_list_size() -> int:
	return list.size()

func _get_size() -> int:
	return pile.size()