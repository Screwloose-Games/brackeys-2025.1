extends Camera3D

var player: CharacterBody3D
var target: Vector3
var looking_at_player: bool

func _ready():
    player = get_tree().get_first_node_in_group("player")
    looking_at_player = true

func _process(_delta: float):
    if looking_at_player:
        look_at(player.global_position)
    elif target != null:
        look_at(target)

func set_new_target(new_target: Vector3):
    target = new_target
    looking_at_player = false
    
func follow_player():
    looking_at_player = true
