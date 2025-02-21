class_name NPC_Action
extends Resource

enum Type {
    ## NPC will wait for a set amount of seconds.
    WAIT,
    ## NPC will move to the given destination.
    MOVE,
    ## NPC will return to the exact global position they started the 
    ## scene at.
    RETURN_TO_STARTING_POSITION,
    ## If the user has not grabbed the rings, the NPC will obtain the rings here.
    PICKS_UP_RINGS,
    ## Loop back to a previous action in the array.
    LOOP,
}

@export var action_type: Type = Type.WAIT
## Time the npc will wait this many seconds until going to the next action.
## Only used if the Action Type is Wait.
@export var wait_time: float
## The destination the NPC will travel to. Only used if 
## the Action Type is Move.
@export var destination: Vector3
## The index of the action the NPC will loop back to. Only used
## if the Action Type is Loop. Example, if you put a 2 here the 
## NPC will go back to the [2] action in this array.
@export var loop_to_step: int

func _init(_action_type:= Type.WAIT, _wait_time:= 0, _destination:=Vector3.ZERO, _loop_to_step:=0):
    action_type = _action_type
    wait_time = _wait_time
    destination = _destination
    loop_to_step = _loop_to_step
    
