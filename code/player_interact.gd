extends Node3D

@export var player_controller: Node3D

signal show_interact_sprite(show: bool)
signal show_dialogue_panel(text: String)
signal hide_dialogue_panel()

var interact_button_sprite: Sprite2D
var can_interact_with_npc: bool
var npc_text: String

var npc_interacting_with: CharacterBody3D

func entered_npc_trigger(npc: CharacterBody3D, text: String):
    can_interact_with_npc = true
    npc_text = text
    npc_interacting_with = npc
    #camera should target npc here
    show_interact_sprite.emit(true)

func left_npc_trigger():
    can_interact_with_npc = false
    #camera should go back to following player here
    show_interact_sprite.emit(false)
    hide_dialogue_panel.emit()
    npc_interacting_with.player_stops_interacting()

func _input(event: InputEvent):
    if event.is_action_pressed("Interact") and can_interact_with_npc:
        player_controller.player_has_interacted()
        show_dialogue_panel.emit(npc_text)
        npc_interacting_with.player_interacts_with_npc()
