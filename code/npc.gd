extends StaticBody3D

@export var npc_text: String 
var interaction_detection: Node3D

@export var loop_actions: bool
@export var actions: Array[NPC_Action] = []

var index: int = 0

func _ready():
    interaction_detection = get_node("InteractionDetection")
    interaction_detection.set_text(npc_text)
    commit_action()

func commit_action():
    var action = actions[index]
    
    print("commiting an action!")
    
    match action.action_type:
        NPC_Action.Type.WAIT:
            wait()
        NPC_Action.Type.MOVE:
            pass
            
func increment_index():
    index += 1
    if index < actions.size() - 1:
        commit_action()
    elif loop_actions:
        index = 0
        commit_action()
    else:
        print("i am done with my actions")

func wait():
    await get_tree().create_timer(actions[index].wait_time).timeout
    increment_index()
