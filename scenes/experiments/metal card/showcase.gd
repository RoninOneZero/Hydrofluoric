extends Node2D

const CardPrinter = preload("res://scenes/experiments/card printer/card_printer.gd")

@export var card_template: PackedScene
@export var card_data: MetalCardData

func _ready() -> void:
	var hud = $Control
	hud.add_child(CardPrinter.instance_card(card_template, card_data))