extends Node

#region Card
signal card_played(_card: Card)
signal card_discarded(_card: Card)
#endregion

#region Deck
signal card_added_to_deck(_card: Card, _deck: Deck)
signal card_removed_from_deck(_card: Card, _deck: Deck)
#endregion
