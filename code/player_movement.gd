extends Node3D

@export var root: CharacterBody3D
@export var speed: float
@export var jump_power: float
@export var mouse_sensitivity: float
@export var fall_speed: float
@export var camera_mount: SpringArm3D
@export var rotation_speed: float
@export var player_model: MeshInstance3D
var target_velocity: Vector3 = Vector3.ZERO

var direction: Vector3 = Vector3.ZERO

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float):
    direction = Vector3.ZERO
    
    if InputManager.input_mode == InputManager.InputMode.PLAYING:
        if Input.is_action_pressed("Move_Forward"):
            direction.z -= 1
        if Input.is_action_pressed("Move_Backward"):
            direction.z += 1
        if Input.is_action_pressed("Move_Right"):
            direction.x += 1
        if Input.is_action_pressed("Move_Left"):
            direction.x -= 1
        
        if root.is_on_floor() and Input.is_action_just_pressed("Jump"):
            target_velocity.y = jump_power
    
    direction = direction.rotated(Vector3.UP, camera_mount.rotation.y)

    if direction != Vector3.ZERO:
        direction = direction.normalized()
        
    target_velocity.x = direction.x * speed
    target_velocity.z = direction.z * speed

    if not root.is_on_floor():
        target_velocity.y = target_velocity.y - (fall_speed * delta)

    root.velocity = target_velocity
    root.move_and_slide()

    if root.velocity.length() > 1.0:
        player_model.rotation.y = lerp_angle(player_model.rotation.y, camera_mount.rotation.y, rotation_speed * delta)

func _unhandled_input(event: InputEvent):
    if event is InputEventMouseMotion:
        camera_mount.rotation.x -= event.relative.y * mouse_sensitivity
        camera_mount.rotation_degrees.x = clamp(camera_mount.rotation_degrees.x, -90.0, 30.0)
        camera_mount.rotation.y -= event.relative.x * mouse_sensitivity
