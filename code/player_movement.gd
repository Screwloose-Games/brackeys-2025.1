extends Node3D

@export var root: CharacterBody3D
@export var speed: float
var target_velocity: Vector3 = Vector3.ZERO

var direction: Vector3 = Vector3.ZERO

func _physics_process(_delta: float):
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
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	root.velocity = target_velocity
	root.move_and_slide()
