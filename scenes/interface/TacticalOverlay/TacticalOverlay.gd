class_name TacticalOverlay
extends Control

@export var deck: MetalDeck

func _ready() -> void:
	initialize_deck(deck)
	print(deck.pile)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and !deck.is_empty():
		showcase(deck.draw())

func initialize_deck(new_deck: MetalDeck) -> void:
	new_deck.create_pile()
	new_deck.shuffle()

func showcase(card: MetalCard) -> void:
	add_child(card)
