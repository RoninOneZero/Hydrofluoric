class_name Deck
extends Resource

# The abstract list of cards that were used to construct the deck
var list: Array

# The cards as a physical stack of cards that can be drawn from and shuffled
var pile: Array

signal shuffled
signal card_drawn


# DEBUG func to create a sample set
func create_decklist() -> void:
	for i in Card.Suit:
		for j in Card.Rank:
			var new_card: Card = Card.new()
			new_card.suit = Card.Suit[i]
			new_card.rank = Card.Rank[j]
			list.append(new_card)

# Generate a new unshuffled pile from deck list for use in game
func create_pile() -> void:
	pile = list.duplicate()


# Remove and return a card from the top of the pile
func draw_card():
	# Error handling
	if pile == null or pile.is_empty():
		return null
	
	emit_signal("card_drawn")
	return pile.pop_front()

# Overload for draw_card()
func draw(amount: int):
	# Error handling
	if amount <= 0:
		return null

	var stack := []
	for n in amount:
		stack.append(draw_card())
	return stack

func shuffle() -> void:
	if pile == null or pile.is_empty():
		return

	pile.shuffle()
	emit_signal("shuffled")
