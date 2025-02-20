extends StaticBody3D

var player_interact: Node3D

# this will return false if the ring bearer gets the rings first.
var can_be_picked_up: bool = true

func _ready():
    player_interact = get_tree().get_first_node_in_group("player").get_node("PlayerInteract")

func on_body_entered(body:Node3D):
    if body.is_in_group("player") and can_be_picked_up:
        player_interact.entered_rings_trigger()

func on_body_left(body:Node3D):
    if body.is_in_group("player"):
        player_interact.left_rings_trigger()

func npc_took_rings():
    can_be_picked_up = false
