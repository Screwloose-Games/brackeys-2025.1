extends CharacterBody3D

@export var SPEED: float
@export var SPRINT_SPEED: float
@export var JUMP_VELOCITY: float
@export var GRAVITY: float
@export var ACCELERATION: float
@export var DECELERATION: float

@onready var _camera: Camera3D

signal player_jumped()
signal player_landed()
signal player_started_walking()
signal player_stopped_walking()
signal player_interacted()

var sprinting: bool
var is_airborne: bool
var is_walking: bool

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
    
    if Input.is_action_pressed("Sprint"):
        sprinting = true
    else:
        sprinting = false

    var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        if not is_walking && is_on_floor():
            player_started_walking.emit()
            is_walking = true
            
        var move_dir: Vector3 = Vector3.ZERO
        move_dir.x = direction.x
        move_dir.z = direction.z

        move_dir = move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
        velocity.x = move_toward(velocity.x, move_dir.x * get_speed(), ACCELERATION)
        velocity.z = move_toward(velocity.z, move_dir.z * get_speed(), ACCELERATION)
    else:
        if is_walking:
            player_stopped_walking.emit()
            is_walking = false
            
        velocity.x = move_toward(velocity.x, 0, DECELERATION)
        velocity.z = move_toward(velocity.z, 0, DECELERATION)
    
    if is_on_floor() and Input.is_action_just_pressed("Jump"):
        player_jumped.emit()
        player_stopped_walking.emit()
        is_walking = false
        velocity.y = JUMP_VELOCITY
        
    if not is_on_floor():
        is_airborne = true
        
    if is_on_floor() and is_airborne:
        is_airborne = false
        player_landed.emit()

    move_and_slide()
    
func get_speed() -> float:
    if sprinting:
        return SPRINT_SPEED
    else:
        return SPEED
        
func player_has_interacted():
    player_interacted.emit()
