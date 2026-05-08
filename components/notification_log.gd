extends Control

@onready var labels:Array[Label] = [$TextLines/Label1, $TextLines/Label2, $TextLines/Label3, $TextLines/Label4, $TextLines/Label5]

func _ready() -> void:
	Events.character_damaged.connect(_on_character_damaged)
	Events.forced_discard.connect(_on_forced_discard)
	Events.looted_cards.connect(_on_looted_cards)
	Events.missing_values.connect(_on_missing_values)

func update(new_message_text:String):
	labels[0].text = labels[1].text
	labels[1].text = labels[2].text
	labels[2].text = labels[3].text
	labels[3].text = labels[4].text
	labels[4].text = new_message_text

func _on_character_damaged(_character:Character, amount:int, source):
	var source_name = "?"
	if "type" in source:
		source_name = Model.ObjectTypes.keys()[source.type]
	update("P" + str(_character.character_id) + " took " + str(amount) + "dmg from " + source_name)

func _on_forced_discard(_character:Character, source):
	var source_name = "?"
	if "type" in source:
		source_name = Model.ObjectTypes.keys()[source.type]
	update("P" + str(_character.character_id) + " force discard from " + source_name)

func _on_looted_cards(_character:Character):
	update("P" + str(_character.character_id) + " looted cards")

func _on_missing_values(_card:Card):
	update("P" + str(_card.owning_character.character_id) + " can't play card, missing values")
