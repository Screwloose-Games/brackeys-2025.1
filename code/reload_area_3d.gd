extends Area3D

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: PhysicsBody3D):
    if body.is_in_group("player"):
        get_tree().reload_current_scene()
