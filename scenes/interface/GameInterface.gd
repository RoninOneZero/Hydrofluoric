extends Control

## Current deck in play
@export var deck: MetalDeck 

@onready var hand: CardSelector = $Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.create_pile()
	deck.shuffle()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		draw_card()

func draw_card() -> void:
	hand.add_card(deck.draw())
