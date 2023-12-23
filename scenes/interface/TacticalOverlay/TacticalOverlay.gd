class_name TacticalOverlay
extends Control

const HANDSIZE := 6

@export var deck: MetalDeck

@onready var hand: MetalHand = $Hand
@onready var deck_status: Label = get_node("StatusMeters/Agent 1/Deck")

func _ready() -> void:
	initialize_deck(deck)
	hand.limit = HANDSIZE

	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if deck.is_empty():
			return
		
		if !hand.is_full():
			var stack = deck.draw(2)
			update_deck_status()
			for card in stack:
				hand.add_card(card)				

		else:
			print("Hand is full")
	
	if event.is_action_pressed("ui_cancel"):
		hand.remove_card(0)
	

# Might need a combined function for drawing and updating.
func update_deck_status() -> void:
	deck_status.text = "🂡 %02d/%02d" % [deck.size, deck.list_size]


func initialize_deck(new_deck: MetalDeck) -> void:
	connect_deck_signals(new_deck)
	new_deck.create_pile()
	new_deck.shuffle()
	update_deck_status()


func connect_deck_signals(new_deck: MetalDeck) -> void:
	new_deck.connect("shuffled", on_shuffled)
	new_deck.connect("card_drawn", on_card_drawn)
	new_deck.connect("deck_emptied", on_deck_emptied) # Possibly unneeded 


func on_shuffled() -> void:
	print("Deck has been shuffled.")

func on_card_drawn() -> void:
	print("A card has been drawn")

func on_deck_emptied() -> void:
	print("Deck is empty!")
