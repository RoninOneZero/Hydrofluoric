class_name DeckHandler
extends Control

@export var deck: Array[MetalCardData]

@onready var inspector: = $Inspector
@onready var hand: = $Hand


var card_template := preload("res://scenes/cards forms/metal card/metal_card.tscn")
var cards_in_hand: Array[MetalCard] = []

var enabled: = false

func _ready() -> void:

	# initialize some cards from given data
	for card in deck:
		var card_node: = card_template.instantiate()
		card_node.update_card(card)
		hand.add_child(card_node)
		print(card_node.name)

func _unhandled_input(event: InputEvent) -> void:
	if !enabled:
		return

	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		print("Dech Handler received confirm input.")