extends CharacterBody3D

@export var movement_speed: float
@export var npc_text: String 
var interaction_detection: Node3D

@export var loop_actions: bool
@export var actions: Array[NPC_Action] = []

@onready var nav_agent: NavigationAgent3D = %NavAgent
var movement_direction: Vector3
var starting_position: Vector3

var being_interacted_with: bool

var index: int = 0

func _ready():
    interaction_detection = get_node("InteractionDetection")
    interaction_detection.set_text(npc_text)
    starting_position = global_position
    commit_action()
    
func _physics_process(_delta):
    if actions[index].action_type == NPC_Action.Type.MOVE:
        determine_navigation(actions[index].destination)
        if nav_agent.is_navigation_finished():
            increment_index()
    elif actions[index].action_type == NPC_Action.Type.RETURN_TO_STARTING_POSITION:
        determine_navigation(starting_position)
        if nav_agent.is_navigation_finished():
            increment_index()

func commit_action():
    var action = actions[index]
    
    match action.action_type:
        NPC_Action.Type.WAIT:
            wait()
            
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
    
func player_interacts_with_npc():
    being_interacted_with = true

func player_stops_interacting():
    being_interacted_with = false

func _on_nav_agent_velocity_computed(safe_velocity: Vector3):
    velocity = safe_velocity
    
func determine_navigation(destination: Vector3):
    if being_interacted_with:
        return
    
    nav_agent.target_position = destination
    var next_path_position = nav_agent.get_next_path_position()
    velocity = global_position.direction_to(next_path_position) * movement_speed
    move_and_slide()
