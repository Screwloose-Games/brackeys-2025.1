extends Control

@export var interact_button_sprite: Sprite2D
@export var follow_button_sprite: Sprite2D
@export var ring_ui_sprite: Sprite2D
@export var dialogue_panel: Panel
@export var dialogue_label: Label

var player_interact: Node3D

func _ready():
    player_interact = get_tree().get_first_node_in_group("player").get_node("PlayerInteract")
    player_interact.connect("show_interact_sprite", set_interact_button_visibility)
    player_interact.connect("show_dialogue_panel", set_dialogue_text)
    player_interact.connect("hide_dialogue_panel", hide_dialogue_panel)
    player_interact.connect("hide_follow_sprite", hide_follow_sprite)
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
