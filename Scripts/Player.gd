extends KinematicBody2D

export var accellearation : float = 50
export var maxSpeed : float = 100
export var slideFactor : float = 0.8
export var gravity : float = 100
export var jumpHeight : float = 100
export var jumpSpeedFactor : float = 0.5
export var wallJumpSpeed : Vector2 = Vector2()
export var wallSlideBoost : float = 50


var velocity = Vector2()
var isFalling = true
var moveDirection = 0
var wallDir = 0

onready var leftRay = $rayLeft
onready var rightRay = $rayRight



func _physics_process(delta):
	# Calculate X movement
	moveDirection = 0
	var correctedAcc = accellearation * _getXAccFactor()
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + correctedAcc, maxSpeed)
		moveDirection += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - correctedAcc, -maxSpeed)
		moveDirection -= 1
	if moveDirection == 0:
		velocity.x *= slideFactor
		
	# Calcualte Y movement
	# Jumping
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y -= jumpHeight + (jumpHeight * abs(velocity.x) / maxSpeed * jumpSpeedFactor)
		elif _check_rays():
			_walljump()
	
	# Calculate wall slide
	if wallDir != 0:
		_wallslide()
	
	
	
	velocity.y += gravity
		
	
	# Commit new velocity
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
func _check_rays():
	wallDir = 0
	if leftRay.is_colliding():
		wallDir -= 1
		return true
	if rightRay.is_colliding():
		wallDir += 1
		return true
	return false

func _walljump():
	print("Walljump")
	velocity += Vector2(wallJumpSpeed.x * wallDir, wallJumpSpeed.y)
	
func _wallslide():
	if Input.is_action_pressed("ui_left") and wallDir < 0:
		velocity.y -= wallSlideBoost
	if Input.is_action_pressed("ui_right") and wallDir > 0:
		velocity.y -= wallSlideBoost
	
	
		
func _getXAccFactor():
	if is_on_floor():
		return 1
	else:
		return 0.1