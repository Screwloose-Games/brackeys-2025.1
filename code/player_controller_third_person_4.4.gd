extends "player_controller_4.4.gd"

@onready var _player_pcam: PhantomCamera3D
@onready var _player_direction: Node3D = %skeletalmesh_player

@export var mouse_sensitivity: float = 0.05

@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360


func _ready() -> void:
    super()

    _player_pcam = owner.get_node("%PlayerPhantomCamera3D")

    if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
    super(delta)

    if velocity.length() > 0.2:
        var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
        _player_direction.rotation.y = look_direction.angle()


func _unhandled_input(event: InputEvent) -> void:
    if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
        _set_pcam_rotation(_player_pcam, event)


func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
    if not InputManager.is_playing_mode():
        return
    if event is InputEventMouseMotion:
        var pcam_rotation_degrees: Vector3

        # Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
        pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()

        # Change the X rotation
        pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity

        # Clamp the rotation in the X axis so it go over or under the target
        pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)

        # Change the Y rotation value
        pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity

        # Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
        pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)

        # Change the SpringArm3D node's rotation and rotate around its target
        pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)
