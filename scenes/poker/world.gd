extends Node3D

@onready var hand: Node3D = $Hand

var deck: Deck = Deck.new()

func _ready() -> void:
    deck.create_decklist()
    deck.create_pile()
    deck.shuffle()
	
    draw_physical_hand()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("draw"):
        draw_physical_hand()


func draw_physical_hand() -> void:
    var virtual_hand: Array = deck.draw(5)

    var physical_hand = hand.get_children()

    for physical_card in physical_hand:
        physical_card.card = virtual_hand[physical_card.get_index()]



    var hand_alias: PackedStringArray = []
    for card in virtual_hand:
        hand_alias.append(card.alias)
    print(hand_alias)