class_name MetalCard
extends Sprite2D

# Components
@onready var type_label := $TypeLabel
@onready var name_label := $NameLabel
@onready var info_label := $InfoLabel
@onready var cost_label := $CostLabel
@onready var portrait_sprite := $PortraitMask/Portrait

# Card stats
var type: String 
#var name
var info: String 
var cost: int 
var portrait: Texture 

# Catalogue stats
var card_ID: int
var rarity: int
var limit: int


func _ready() -> void:
	update_card()

## Populate blank card with information.
func inscribe_card(new_data: MetalCardData) -> void:
	type = new_data.type
	name = new_data.name 
	info = new_data.info
	cost = new_data.cost
	portrait = new_data.portrait
	card_ID = new_data.card_ID
	rarity = new_data.rarity
	limit = new_data.limit

func update_card() -> void:
	type_label.text = type
	name_label.text = name
	info_label.text = info
	cost_label.text = str(cost)
	portrait_sprite.texture = portrait

func _on_renamed() -> void:
	name_label.text = name

