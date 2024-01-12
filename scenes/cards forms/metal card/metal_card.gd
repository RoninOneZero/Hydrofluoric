# Learn how to use a constructor

class_name MetalCard
extends Control
# Visual settings
# @export var font_normal: Font
# @export var font_mini: Font

@export var data: MetalCardData = preload("res://card resources/cards/metal cards/blank_card.tres")

# Components
# @onready var type_label:Label = $TypeLabel
# @onready var name_label:Label = $NameLabel
# @onready var info_label: RichTextLabel = $InfoLabel
# @onready var cost_label:Label = $CostLabel
# @onready var portrait_sprite:Sprite2D = $PortraitMask/Portrait


# Card stats
var type:String
var card_name:String
var info:String 
var cost:int 
var portrait:Texture 
var movement:int

# Catalogue stats
var card_ID:int
var rarity:int
var limit:int


## Instances a new card with the provided data. "mini_ver" if true creates the small version of the card.
# func _init() -> void:
# 	update_card(data)

func _enter_tree() -> void:
	name = card_name

#TODO needs a helper function to actually change the scene's values
func update_card(new_data:MetalCardData) -> void:
	type = new_data.type
	$TypeLabel.text = type

	card_name = new_data.name
	$NameLabel.text = card_name
	name = card_name

	info = new_data.info
	$InfoLabel.text = info

	cost = new_data.cost
	$CostLabel.text = str(cost)

	portrait = new_data.portrait
	$PortraitMask/Portrait.texture = portrait

	card_ID = new_data.card_ID
	rarity = new_data.rarity
	limit = new_data.limit
	data = new_data

