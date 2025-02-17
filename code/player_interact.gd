extends Node3D

@export var camera_controller: Camera3D

signal show_interact_sprite(show: bool)

var interact_button_sprite: Sprite2D
var can_interact_with_npc: bool
var npc_text: String

func entered_npc_trigger(npc_position: Vector3, text: String):
    can_interact_with_npc = true
    npc_text = text
    camera_controller.set_new_target(npc_position)
    show_interact_sprite.emit(true)

func left_npc_trigger():
    can_interact_with_npc = false
    camera_controller.follow_player()
    show_interact_sprite.emit(false)

func _input(event: InputEvent):
    if event.is_action_pressed("Interact") and can_interact_with_npc:
        print(npc_text)
