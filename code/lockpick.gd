extends StaticBody3D

@export var spin_speed: float

var player_interact: Node3D
var disc: Sprite2D

signal show_lockpicking_sprites(show: bool)

# this will return false once the lock has been picked once.
var can_be_unlocked: bool = true
var is_spinning: bool = false

func _ready():
    player_interact = get_tree().get_first_node_in_group("player").get_node("PlayerInteract")
    disc = get_tree().get_first_node_in_group("lock_picking_disc")
    
func _process(delta):
    if is_spinning:
        disc.rotation += delta * spin_speed
        
func _input(event):
    if event.is_action_pressed("Stop Lock Pick") and is_spinning:
        is_spinning = false
        check_if_mini_game_won()
    
    if event.is_action_pressed("Interact") and is_spinning:
        show_lockpicking_sprites.emit(false)
        is_spinning = false
        await get_tree().process_frame
        InputManager.set_input_mode(InputManager.InputMode.PLAYING)
        

func on_body_entered(body:Node3D):
    if body.is_in_group("player") and can_be_unlocked:
        player_interact.entered_lock_pick_trigger()

func on_body_left(body:Node3D):
    if body.is_in_group("player"):
        player_interact.left_lock_pick_trigger()
        
func start_lock_pick_mini_game():
    InputManager.set_input_mode(InputManager.InputMode.LOCKPICKING)
    is_spinning = true
    
func check_if_mini_game_won():
    if (disc.rotation_degrees > -25 and disc.rotation_degrees < 25) or (disc.rotation_degrees < -333 or disc.rotation_degrees > 333):
        #succeeded
        can_be_unlocked = false
        WinManager.player_picked_lock()
        show_lockpicking_sprites.emit(false)
        await get_tree().process_frame
        InputManager.set_input_mode(InputManager.InputMode.PLAYING)
    else:
        # failed
        await get_tree().create_timer(1).timeout
        is_spinning = true
        
    
