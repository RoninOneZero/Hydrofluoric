class_name Card
extends Resource

enum Suit {HEART, SPADE, DIAMOND, CLUB}
@export var suit: Suit

enum Rank {
	ACE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	TEN,
	JACK,
	QUEEN,
	KING}
@export var rank: Rank

var alias: String : get = get_alias

func get_alias() -> String:
	var glyph: String

	match suit:
		0: glyph = "♥"
		1: glyph = "♠"
		2: glyph = "♦"
		3: glyph = "♣"


	return str(glyph, " ", Rank.find_key(rank))