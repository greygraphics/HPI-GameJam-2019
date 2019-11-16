extends KinematicBody2D

export var MAX_SPEED : float = 120
export var ACCELLERATION : float = 4
export var AIR_ACC_FACTOR : float = 0.7
export var SLIDE_FACTOR : float = 0.5
export var JUMP_HEIGHT : float = 200
export var DOUBLE_JUMP_HEIGHT : float = 100
export var JUMP_SPEED_FACTOR : float = 0.2
export var WALLSLIDE_FACTOR : float = 0.1
export var GRAVITY : float = 8
export var WALL_JUMP_SPEED : Vector2 = Vector2()

enum STATES {
	FLOOR,
	AIR,
	WALL
}

var velocity : Vector2 = Vector2()
var wallDir = 0
var moveDir = 0
var state = STATES.FLOOR
var doubleJumpReady = true

func _process(delta):
	$RichTextLabel.text = STATES.keys()[state]

func _physics_process(delta):
	_updateState()
	# Get X Input
	_updateMoveDir()
	# Get accelleration factor
	var accFactor = 1
	match state:
		STATES.AIR:
			accFactor = AIR_ACC_FACTOR
	# Break if nothing pressed
	if moveDir == 0:
		velocity.x *= SLIDE_FACTOR
	# Move player on X
	velocity.x += moveDir * accFactor * ACCELLERATION
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	_checkWalls()
	var gravityScale = 1
	# wallslide
	gravityScale *= _wallslide()
	# hover

	print(gravityScale)
	if _jump() or _walljump() or _doubleJump():
		print("No gravity!")
	else:
		velocity.y += gravityScale * GRAVITY
	
	# apply movement
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _updateMoveDir():
	moveDir = 0
	if Input.is_action_pressed("ui_left"):
		moveDir -= 1
	if Input.is_action_pressed("ui_right"):
		moveDir += 1



func _checkWalls():
	wallDir = 0
	if $rayLeft.is_colliding():
		wallDir -= 1
	if $rayRight.is_colliding():
		wallDir += 1
		
func _wallslide():
	if moveDir == wallDir and moveDir != 0 and velocity.y > 0:
		return WALLSLIDE_FACTOR
	return 1
	
func _jump():
	if !Input.is_action_just_pressed("ui_up") or state != STATES.FLOOR or !_canJump():
		return false
	state = STATES.AIR
	velocity.y = -JUMP_HEIGHT
	if $Timer.is_stopped():
		$Timer.start()
	return true

func _doubleJump():
	if !Input.is_action_just_pressed("ui_up") or state != STATES.AIR:
		return false
	if !doubleJumpReady:
		return false 
	doubleJumpReady = false
	velocity.y = -DOUBLE_JUMP_HEIGHT
	if $Timer.is_stopped():
		$Timer.start()
	return true
	
func _walljump():
	if !Input.is_action_just_pressed("ui_up") or wallDir == 0 or !_canJump():
		return false
	var dx = WALL_JUMP_SPEED.x * -wallDir
	velocity.x = dx
	velocity.y = -WALL_JUMP_SPEED.y
	
	if $Timer.is_stopped():
		$Timer.start()
	return true
	
func _updateState():
	if is_on_floor():
		state = STATES.FLOOR
		doubleJumpReady = true
	elif wallDir != 0:
		state = STATES.WALL
	else:
		state = STATES.AIR
		
func _canJump():
	return $Timer.is_stopped()
	
func _animate():
	$Textures._setDirection(moveDir)
	$Textures._setRolling(moveDir != 0)
	$Textures._setWallSlide(state == STATES.WALL and Input.is_action_pressed("ui_up"))