class_name CardCatalogue
extends Resource

## Editable list of cards in catalogue. Watch out for duplicates.
@export var card_list: Array[MetalCardData] = []

## The packed scene to be used as a template
@export var card_template: PackedScene

##Returns a card object for use in play given an ID. Returns null if ID not found.
func get_card(ID: int) -> MetalCard:
	var target = _get_data(ID)    
	return CardPrinter.instance_card(card_template, target)

## Return data at given ID number. Not meant to be used externally.
func _get_data(ID: int) -> MetalCardData:
	return card_list[ID]

## Return ID number of given data, or -1 if no data is found.
func get_ID(data: MetalCardData) -> int:
	return card_list.find(data)

#TODO use count() to find duplicates