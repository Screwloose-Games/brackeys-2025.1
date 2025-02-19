extends Node

var player_has_ring: bool = false

signal show_ring_sprite()

func player_obtained_ring():
    player_has_ring = true
    show_ring_sprite.emit()
    print("player has obtained the ring!")
    
