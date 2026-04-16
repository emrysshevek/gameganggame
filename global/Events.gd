extends Node

#region Creature Value
signal value_changed(_value: Model.CreatureValue)
#endregion

#region Card
signal card_played(_card: Card)
signal card_discarded(_card: Card)
signal missing_values(_card :Card)
#endregion

#region Deck
signal card_added_to_deck(_card: Card, _deck: Deck)
signal card_removed_from_deck(_card: Card, _deck: Deck)
#endregion

#region Turn
signal game_started()
signal game_ended()
signal round_started()
signal round_ended()
signal player_turn_ended(_character: Character)
#endregion

#region Input State Machine
signal request_input_state_transition(new_state:String, requesting_character:Character)
#endregion

#region Character
signal character_damaged(_character: Character, _amount:int, effect_source)
signal character_moved(_character: Character, old_coords: Vector2i, new_coords: Vector2i)
signal looted_cards(_character: Character)
signal forced_discard(_character: Character, effect_source)
#endregion

#region Tile
signal tile_entered(_tile: Tile, _character: Character)
signal tile_exited(_tile: Tile, _character: Character)
signal tile_revealed(_tile: Tile, _character: Character)
signal tile_explored(_tile: Tile, _character: Character)
#endregion

#region Status
signal status_applied(_status: Status, target: Node)
signal status_added(_status: Status, target: Node)
signal status_removed(_status: Status, target: Node)
signal status_triggered(_status: Status, target: Node)
#endregion
