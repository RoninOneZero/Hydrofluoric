class_name TacticalOverlay
extends Control

const HANDSIZE := 6

@export var agent: Node3D
@export var gridmap: GridMap

@export var deck: MetalDeck
@onready var catalogue:CardCatalogue = deck.catalogue

@onready var hand: MetalHand = $Hand
@onready var deck_status: Label = get_node("StatusMeters/Agent 1/Deck")

#TODO add a cards in hand status label

var graveyard: Array[MetalCard] = []

signal movement_order

func _ready() -> void:
	hand.limit = HANDSIZE
	initialize_deck(deck)
	hand.connect("card_played", on_card_played)

	
# All this fucking sucks
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		draw_from_deck(1)
	# create a discard function that returns card to its original state.
	if event.is_action_pressed("ui_cancel"):
		discard_from_hand(0)

# For now this only does movement
## Resolves the effect or movement of a card. Also Messy
func on_card_played(index: int, arg) -> void:
	discard_from_hand(index)
	var movement: int = arg
	# talk to gridmap about what tile this movement can reach
	# send destination tile to Agent



## Draw a single card from the deck. Does nothing if hand is full
func draw_from_deck(amount: int = 1, target_deck: MetalDeck = deck, target_hand: MetalHand = hand) -> void:
	# Reduce amount to remaining slots in hand.
	var open_hand_slots: int = target_hand.limit - target_hand.contents.size()
	if amount > open_hand_slots:
		amount = open_hand_slots

	# Check if a card needs to be drawn.
	for i in amount:
		# If hand is full, halt operation.
		if target_hand.is_full():
			return
		# Operation is valid, so we check if deck needs reloading, then draw card.
		if target_deck.is_empty():
			reload_deck()
		target_hand.add_card(deck.draw())
	# Since we modified the deck, update the status label.
	update_deck_status()

## Shuffles graveyard into deck.
func reload_deck(target_deck := deck, target_grave := graveyard) -> void:
	target_deck.pile.append_array(target_grave)
	target_grave.clear()
	target_deck.shuffle()
	update_deck_status()

## Discard a card from hand at given index.
func discard_from_hand(index: int, target_hand := hand, target_grave := graveyard) -> void:
	var card: MetalCard
	card = target_hand.take_card(index)
	if card == null: # If card does not exist, abort.
		return 
	target_grave.append(restore_card(card))
	card.queue_free()


## Sets deck display. TODO needs specification of which deck
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

## Returns an unmodfied copy of a given card. Messy function
func restore_card(card: MetalCard) -> MetalCard:
	return catalogue.get_card(card.card_ID)

# Signals
func on_shuffled() -> void:
	print("Deck has been shuffled.")

func on_card_drawn() -> void:
	print("A card has been drawn")

func on_deck_emptied() -> void:
	print("Deck is empty!")
