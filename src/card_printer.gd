class_name CardPrinter

## Create an uninstanced node based on given card data.
static func instance_card(template: PackedScene, data: MetalCardData)  -> Node:
	var card: MetalCard = template.instantiate()
	card.inscribe_card(data)
	return card
