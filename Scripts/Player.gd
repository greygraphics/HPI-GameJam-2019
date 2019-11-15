extends KinematicBody2D

export var speed : float = 1
export var gravity : float = 10
export var jumpStrength : float = 100

var velocity = Vector2()

func _physics_process(delta):
	velocity.y += delta * gravity;
	velocity.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	move_and_slide(velocity, Vector2(0,-1))