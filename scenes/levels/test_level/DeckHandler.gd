###	Hold the deck list as an array of card datas
### a card object should be a class object based off the card data, and hold a ref to the data
### a card UI object should be "stupid" and hold no data of its own.

class_name DeckHandler
extends Control

@export var enabled: = false
@export var deck: Array[MetalCardData]

@onready var inspector: = $Inspector
@onready var hand: = $Hand

var hand_limit: = 6

var card_template := preload("res://scenes/cards forms/metal card/metal_card.tscn")
var cards_in_hand: Array[MetalCard] = [] 


func _ready() -> void:

	# initialize some cards from given data
	for card in deck:
		var card_node: = card_template.instantiate()
		card_node.update_card(card)
		place_card_in_hand(card_node)
		

func _unhandled_input(event: InputEvent) -> void:
	if !enabled:
		return

	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		print("Dech Handler received confirm input.")

func place_card_in_hand(card:Control) -> void:
	if cards_in_hand.size() >= hand_limit:
		return

	cards_in_hand.append(card)	
	hand.add_child(card)

# Maybe this should return the amount of cards drawn?
func draw_to_limit() -> void:
	var difference = hand_limit - cards_in_hand.size()
	if difference > 0:
		for i in difference:
			place_card_in_hand(deck.pop_front())