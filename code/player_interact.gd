extends Node3D

@export var player_controller: Node3D

signal show_interact_sprite(show: bool)
signal show_dialogue_panel(text: String)
signal hide_dialogue_panel()
signal hide_follow_sprite()

var interact_button_sprite: Sprite2D
var can_interact_with_npc: bool
var npc_text: String
var currently_interacting: bool
var has_npc_following: bool

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
    currently_interacting = false
    if not has_npc_following:
        hide_follow_sprite.emit()

func _input(event: InputEvent):
    if event.is_action_pressed("Interact") and can_interact_with_npc:
        player_controller.player_has_interacted()
        show_dialogue_panel.emit(npc_text)
        npc_interacting_with.player_interacts_with_npc()
        currently_interacting = true
        
    if event.is_action_pressed("Follow"):
        if currently_interacting && not has_npc_following:
            #tell npc to start following
            hide_dialogue_panel.emit()
            npc_interacting_with.start_following_player()
            has_npc_following = true
            
        elif has_npc_following:
            # tell npc to stop following
            has_npc_following = false
            npc_interacting_with.stop_following_player()
            hide_follow_sprite.emit()
