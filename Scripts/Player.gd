extends KinematicBody2D

export var accellearation : float = 50
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
	# Jumping
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y -= jumpHeight
		elif _check_rays($wallRays):
			_walljump()
	velocity.y += gravity * delta
		
	
	# Commit new velocity
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
func _check_rays(wall_rays):
	for ray in wall_rays.get_children():
		if ray.is_colliding():
			print("Ray hit!")
			return true
	return false

func _walljump():
	velocity.y -= jumpHeight
	if $wallRays/rayLeft.is_colliding():
		velocity.x += accellearation
	else:
		velocity.x -= accellearation