extends Node3D

@export var card: Card : set = set_card
@export var portrait: Texture2D

@onready var label := $Label
@onready var decal := $Decal

func _ready() -> void:
	if card == null:
		card = Card.new()
	
	decal.texture_albedo = portrait

func set_card(new_card: Card) -> void:
	card = new_card
	if label:
		label.text = card.alias
