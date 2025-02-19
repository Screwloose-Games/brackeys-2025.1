class_name NPC_Action
extends Resource

enum Type {
    WAIT,
    MOVE,
}

@export var action_type: Type = Type.WAIT
@export var wait_time: float
@export var destination: Vector3

func _init(_action_type:= Type.WAIT, _wait_time:= 0, _destination:=Vector3.ZERO):
    action_type = _action_type
    wait_time = _wait_time
    destination = _destination
