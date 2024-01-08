class_name DeckHandler
extends Control

@export var deck: Array[MetalCardData]

var card_template := preload("res://scenes/cards forms/metal card/metal_card.tscn")

var card_list := []

func _ready() -> void:
	# initialize some cards from given data
	for card in deck:
		card_list.append(CardPrinter.instance_card(card_template, card))
	
	print(card_list)