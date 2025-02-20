class_name NPC_Action
extends Resource

enum Type {
    WAIT,
    MOVE,
    RETURN_TO_STARTING_POSITION,
    PICKS_UP_RINGS,
    LOOP,
}

@export var action_type: Type = Type.WAIT
@export var wait_time: float
@export var destination: Vector3
@export var loop_to_step: int

func _init(_action_type:= Type.WAIT, _wait_time:= 0, _destination:=Vector3.ZERO, _loop_to_step:=0):
    action_type = _action_type
    wait_time = _wait_time
    destination = _destination
    loop_to_step = _loop_to_step
    
