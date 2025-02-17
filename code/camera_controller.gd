extends Camera3D

@export var camera_mount: SpringArm3D
@export var follow_speed: float

var player: CharacterBody3D
var target: Vector3
var looking_at_player: bool

func _ready():
    player = get_tree().get_first_node_in_group("player")
    looking_at_player = true

func _process(delta: float):
    if looking_at_player:
        look_at(player.global_position)
        camera_mount.global_position = camera_mount.global_position.lerp(player.global_position, delta * follow_speed)
    elif target != null:
        look_at(target)
        camera_mount.global_position = camera_mount.global_position.lerp(target, delta * follow_speed)

func set_new_target(new_target: Vector3):
    target = new_target
    looking_at_player = false
    camera_mount.spring_length = 3
    
func follow_player():
    looking_at_player = true
    camera_mount.spring_length = 10
