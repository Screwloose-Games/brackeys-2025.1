extends Control

@export var interact_button_sprite: Sprite2D
@export var follow_button_sprite: Sprite2D
@export var ring_ui_sprite: Sprite2D
@export var dialogue_panel: Panel
@export var dialogue_label: Label
@export var lock_picking_sprites: Control
@export var ending_panel: Panel

var player_interact: Node3D
var lock_pick_holder: StaticBody3D

func _ready():
    player_interact = get_tree().get_first_node_in_group("player").get_node("PlayerInteract")
    player_interact.connect("show_interact_sprite", set_interact_button_visibility)
    player_interact.connect("show_dialogue_panel", set_dialogue_text)
    player_interact.connect("hide_dialogue_panel", hide_dialogue_panel)
    player_interact.connect("hide_follow_sprite", hide_follow_sprite)
    player_interact.connect("show_lockpicking_sprites", set_lockpicking_visibility)
    lock_pick_holder = get_tree().get_first_node_in_group("lock")
    GlobalSignalBus.connect("set_ending_visibility", set_ending_visibility)
    
    if lock_pick_holder != null:
        lock_pick_holder.connect("show_lockpicking_sprites", set_lockpicking_visibility)
    WinManager.connect("show_ring_sprite", show_ring_ui)

func set_interact_button_visibility(show_sprite: bool):
    interact_button_sprite.visible = show_sprite

func set_dialogue_text(text: String):
    dialogue_panel.visible = true
    dialogue_label.text = text
    interact_button_sprite.visible = false
    follow_button_sprite.visible = true

func hide_dialogue_panel():
    dialogue_panel.visible = false
    
func hide_follow_sprite():
    follow_button_sprite.visible = false
    
func show_ring_ui():
    ring_ui_sprite.visible = true
    
func set_lockpicking_visibility(show_sprite: bool):
    lock_picking_sprites.visible = show_sprite
    
func set_ending_visibility(show_ending_panel: bool):
    ending_panel.visible = show_ending_panel
    if show_ending_panel:
        InputManager.set_input_mode(InputManager.InputMode.END_GAME_PANEL)
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    
func end_game_yes_button_pressed():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    ending_panel.visible = false
    if WinManager.has_player_won():
        print("you won!")
    else:
        print("you lost!")
    # handle game winning here.
    # idk, zoom in on each ga
    
func end_game_no_button_pressed():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    ending_panel.visible = false
    InputManager.set_input_mode(InputManager.InputMode.PLAYING)
