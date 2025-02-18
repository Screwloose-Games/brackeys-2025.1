extends CharacterBody3D

@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var GRAVITY: float

@onready var _camera: Camera3D

func _ready() -> void:
        _camera = owner.get_node("%MainCamera3D")
        
func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= GRAVITY * delta
    
    var input_dir: Vector2 = Input.get_vector(
        "Move_Left",
        "Move_Right",
        "Move_Forward",
        "Move_Backward",
    )

    var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        var move_dir: Vector3 = Vector3.ZERO
        move_dir.x = direction.x
        move_dir.z = direction.z

        move_dir = move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
        velocity.x = move_dir.x * SPEED
        velocity.z = move_dir.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
    
    if is_on_floor() and Input.is_action_just_pressed("Jump"):
        velocity.y = JUMP_VELOCITY

    move_and_slide()
