extends Node

#region Card
signal card_played(_card: Card)
signal card_discarded(_card: Card)
#endregion

#region Deck
signal card_added_to_deck(_card: Card, _deck: Deck)
signal card_removed_from_deck(_card: Card, _deck: Deck)
#endregion

signal game_started()
signal game_ended()
signal round_started()
signal round_ended()
signal player_turn_ended(_character: Character)
