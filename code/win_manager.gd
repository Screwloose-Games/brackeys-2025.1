extends Node

var player_has_ring: bool = false
var player_has_picked_lock: bool = false

signal show_ring_sprite()

func player_obtained_ring():
    player_has_ring = true
    show_ring_sprite.emit()
    print("player has obtained the ring!")
    
func player_picked_lock():
    player_has_picked_lock = true
    print("player has picked the lock!")
    
