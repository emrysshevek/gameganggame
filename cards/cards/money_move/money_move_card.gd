extends Card

##Add X movement where x is # of resource cards in hand

func _trigger_play_ability() -> void:
	var resource_card_count:int = 0
	var cards_in_hand:Array[Card] = owning_character.my_screen.card_manager.hand_pile.cards
	for each_card in cards_in_hand:
		if each_card is LootCard:
			resource_card_count += 1
	owning_character.movement += resource_card_count
	super._trigger_play_ability()
