extends Control

## Current deck in play
@export var deck: MetalDeck 

@onready var hand: CardSelector = $Hand
@onready var deck_status: Label = get_node("StatusMeters/Agent 1/Deck")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.create_pile()
	deck.shuffle()
	update_deck_status()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		draw_card()
		update_deck_status()

func draw_card() -> void:
	if hand.is_full():
		print("Hand is full.")
		return
	hand.add_card(deck.draw())

func update_deck_status() -> void:
	deck_status.text = str("🂡 ", deck.size, "/", deck.list_size)
