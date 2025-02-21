extends Node3D

@export var door_model: MeshInstance3D

var player_interact: Node3D
var is_open: bool

func _ready():
    player_interact = get_tree().get_first_node_in_group("player").get_node("PlayerInteract")

func on_body_entered(body: Node3D):
    if body.is_in_group("player"):
        player_interact.entered_door_trigger(self)
        
func on_body_left(body: Node3D):
    if body.is_in_group("player"):
        player_interact.left_door_trigger()
        
func interact_with_door():
    if is_open:
        door_model.rotation_degrees = Vector3(0, 0, 0)
    else:
        door_model.rotation_degrees = Vector3(0, -90, 0)
        
    is_open = !is_open
