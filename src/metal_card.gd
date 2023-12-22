class_name MetalCard
extends Resource


# Game stats
## The "use" category of the card
@export_enum("Weapon", "Action", "Support", "Item", "Character") var type: String = "Item"
## Lexigraphic identifier.
@export var name: String = "Blank"
## Description of the cards effects, may contain flavor text.
@export_multiline var info: String = " This card has no function."
## Cost in time units to play this card. The default value of "4" is considered a standard amount.
@export_range(0, 99) var cost: int = 4
## Texture to be displayed as the card's art. TODO requirements
@export var portrait: Texture = preload("res://assets/icon.svg")

# Meta / Deckbuilding stats
## The in-system card identifier. Set externally by the card catalogue
var card_ID: int = -1
## Liklihood of the card appearing in booster packs.
@export_range(1, 5) var rarity: int  = 1
## How many of the card that is allowed in a deck list.
@export_range(1, 4) var limit: int = 4

