extends Node3D

@export var npc_text: String

var player_interact: Node3D

func _ready():
    player_interact = get_tree().get_first_node_in_group("player").get_node("PlayerInteract")
	
func on_body_entered(body:Node3D):
    if body.is_in_group("player"):
        player_interact.entered_npc_trigger(global_position, npc_text)

func on_body_left(body:Node3D):
    if body.is_in_group("player"):
        player_interact.left_npc_trigger()
