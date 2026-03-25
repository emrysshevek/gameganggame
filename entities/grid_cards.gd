class_name GridCards extends GridSprite

var pile:Pile
var _face_up:bool

func _ready() -> void:
	centered = false
	pile = Pile.new()
	visible = false
	
func set_facing(set_face_up:bool):
	if set_face_up == true:
		_face_up = true
		texture = load("res://art/face_up_pile.png")
	else:
		_face_up = false
		texture = load("res://art/face_down_card.png")
	
func add_card(card:Card):
	pile.add_card(card, -1, true)

func take_top_card() -> Card:
	if pile.count > 0:
		var top_card = pile.get_top_card()
		if pile.count == 0:
			self.visible = false
			self.queue_free()
		return top_card
	else:
		print("attempting to take a card from an empty pile, pile should be gone already")
		assert(false)
		return null
