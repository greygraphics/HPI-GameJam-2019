extends KinematicBody2D

export var accellearation : float = 5
export var maxSpeed : float = 100
export var slideFactor : float = 0.8
export var gravity : float = 100
export var jumpHeight : float = 100
export var jumpSpeedFactor : float = 0.2

var velocity = Vector2()
var isFalling = true

func _physics_process(delta):
	# Calculate X movement
	var hasXInput = false
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + accellearation, maxSpeed)
		hasXInput = true
	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - accellearation, -maxSpeed)
		hasXInput = true
	if !hasXInput:
		velocity.x *= slideFactor
		
	# Calcualte Y movement
	var gravityScale = 1
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jumpHeight
	isFalling = velocity.y > 0
	# Let player "float" if holding up
	if Input.is_action_pressed("ui_up") and isFalling:
		gravityScale = 0.5
	velocity.y += gravity * gravityScale * delta
	
	# Commit new velocity
	velocity = move_and_slide(velocity, Vector2(0, -1))
