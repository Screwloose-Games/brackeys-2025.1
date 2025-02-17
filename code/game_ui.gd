extends Control

@export var interact_button_sprite: Sprite2D

var player_interact: Node3D

func _ready():
    player_interact = get_tree().get_first_node_in_group("player").get_node("PlayerInteract")
    player_interact.connect("show_interact_sprite", set_interact_button_visibility)

func set_interact_button_visibility(show_sprite: bool):
    interact_button_sprite.visible = show_sprite
