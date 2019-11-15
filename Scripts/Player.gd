extends KinematicBody2D

export var speed : float = 1
export var gravity : float = 100
export var jumpHeight : float = 100
export var wallBreak : float = 50

var velocity = Vector2()

func _physics_process(delta):
	var gravityFactor = 1
	velocity.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jumpHeight
	if Input.is_action_pressed("ui_up"):
		gravityFactor *= 0.5
	if is_on_wall():
		gravityFactor *= 0.5
	
	velocity.y += delta * gravity * gravityFactor;
	velocity = move_and_slide(velocity, Vector2(0,-1))