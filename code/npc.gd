extends CharacterBody3D

enum AnimationState {
    HIDE,
    IDLE,
    LEAN_WALL,
    RUN_FORWARD,
    SIT,
    STAND_CHATTING,
    STAND_NERVOUS,
    STAND_PHONE,
    WALK_FORWARD
}

@export var animation_state: AnimationState = AnimationState.IDLE

## Should only ever be one NPC with this checked.
@export var is_bride: bool
@export var is_masc: bool
@export var has_ring: bool
@export var movement_speed: float
@export var npc_text: String
## Text that an NPC will say after an important event with them has happened. 
## For example, what the ring bearer says after you take the ring from him.
@export var npc_second_text: String
var interaction_detection: Node3D

@export var stopped_follow_wait_time: float
@export var loop_actions: bool
@export var actions: Array[NPC_Action] = []

@onready var nav_agent: NavigationAgent3D = %NavAgent
@onready var npc_phantom_cam: PhantomCamera3D = %NpcPhantomCam

@onready var npc_audio: NpcAudioPlayer = $NpcAudioPlayer

@onready var rng = RandomNumberGenerator.new()

var rings_holder: StaticBody3D
var player: CharacterBody3D

var movement_direction: Vector3
var starting_position: Vector3

var being_interacted_with: bool
var following_player: bool
var waiting_after_following: bool
var should_use_second_text: bool

var index: int = 0



func _ready():
    player = get_tree().get_first_node_in_group("player")
    rings_holder = get_tree().get_first_node_in_group("rings")
    interaction_detection = get_node("InteractionDetection")
    starting_position = global_position
    commit_action()
    
func _physics_process(_delta):
    
    if following_player:
        determine_navigation(player.global_position, true)
        return
    
    if actions.size() == 0:
        return
    
    if actions[index].action_type == NPC_Action.Type.MOVE:
        determine_navigation(actions[index].destination, false)
        if nav_agent.is_navigation_finished():
            increment_index()
    elif actions[index].action_type == NPC_Action.Type.RETURN_TO_STARTING_POSITION:
        determine_navigation(starting_position, false)
        if nav_agent.is_navigation_finished():
            increment_index()

func commit_action():
    if (actions.size() == 0):
        return
        
    var action = actions[index]
    
    match action.action_type:
        NPC_Action.Type.WAIT:
            wait()
        NPC_Action.Type.PICKS_UP_RINGS:
            picks_up_rings()
        NPC_Action.Type.LOOP:
            loop_to_step()
            
func increment_index():
    index += 1
    if index < actions.size():
        commit_action()
    elif loop_actions:
        index = 0
        commit_action()
    else:
        print("i am done with my actions")

func wait():
    await get_tree().create_timer(actions[index].wait_time).timeout
    increment_index()
    
func picks_up_rings():
    if not WinManager.player_has_ring and not has_ring:
        has_ring = true
        increment_index()
        rings_holder.npc_took_rings()
        print("npc has rings!")
    increment_index()

func loop_to_step():
    index = actions[index].loop_to_step
    commit_action()
    
func player_interacts_with_npc():
    being_interacted_with = true
    npc_phantom_cam.priority = 20
    if has_ring:
        should_use_second_text = true
        has_ring = false
        WinManager.player_obtained_ring()
    npc_audio.play_sound(NpcAudioPlayer.NpcSounds.INTERACT)

func player_stops_interacting():
    being_interacted_with = false
    npc_phantom_cam.priority = 0
    
func start_following_player():
    following_player = true
    
func stop_following_player():
    following_player = false
    waiting_after_following = true
    await get_tree().create_timer(stopped_follow_wait_time).timeout
    waiting_after_following = false
    
func get_text() -> String:
    if should_use_second_text:
        return npc_second_text
    elif npc_text == "":
        return get_random_response_string()
    else:
        return npc_text

func _on_nav_agent_velocity_computed(safe_velocity: Vector3):
    velocity = safe_velocity
    
func determine_navigation(destination: Vector3, following_player: bool):
    if being_interacted_with or waiting_after_following:
        return
    
    nav_agent.target_position = destination
    var next_path_position = nav_agent.get_next_path_position()
    if following_player and not (global_position.distance_to(nav_agent.target_position) - nav_agent.target_desired_distance) <= 0.0:
        velocity = global_position.direction_to(next_path_position) * movement_speed
    move_and_slide()
    
func get_random_response_string() -> String:
    var roll = rng.randi_range(0, 4)
    match roll:
        0:
            return "Do I know you?"
        1:
            return "I'm not sure why you're talking to me."
        2:
            return "I don't think I can help you."
        3:
            return "Do you need something?"
        _:
            return "I'm busy."
