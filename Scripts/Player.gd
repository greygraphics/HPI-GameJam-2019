extends KinematicBody2D

export var MAX_SPEED : float = 8
export var ACCELLERATION : float = 1
export var AIR_ACC_FACTOR : float = 0.5
export var SLIDE_FACTOR : float = 0.8
export var JUMP_HEIGHT : float = 16
export var WALLSLIDE_FACTOR : float = 0.5
export var GRAVITY : float = 8

enum STATES {
	FLOOR,
	AIR,
	WALL
}

var velocity : Vector2 = Vector2()
var wallDir = 0
var moveDir = 0
var state = STATES.FLOOR


func _physics_process(delta):
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
	
	_checkWalls()
	# Get Y input
	# jump
	_jump()
	_walljump()
	
	var gravityScale = 1
	# wallslide
	gravityScale *= _wallslide()
	# hover
	# apply gravity
	velocity.y += gravityScale * GRAVITY
	
	# apply movement
	velocity = move_and_slide(velocity, Vector2.DOWN)
	pass
	
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
	if moveDir == wallDir:
		return WALLSLIDE_FACTOR
	return 1
	
func _jump():
	pass
	
func _walljump():
	pass
	