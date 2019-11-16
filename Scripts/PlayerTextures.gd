extends Node2D

onready var animations = [$Arms, $WheelChair/Wheel]
onready var wheelSpeed = $WheelChair/Wheel.speed_scale

func _setDirection(direction):
	if direction < 0:
		scale.x = -1
	elif direction > 0:
		scale.x = 1
	
func _setRolling(isRolling):
	for animation in animations:
		var animSprite : AnimatedSprite = animation
		animSprite._set_playing(isRolling)
		
func _setWallDirection(direction):
	if direction == 0:
		$WheelChair/Wheel.scale.x = 1
		$WheelChair/Wheel.speed_scale = wheelSpeed
		return
	scale.x = -direction
	$WheelChair/Wheel.scale.x = -1
	$WheelChair/Wheel.speed_scale = wheelSpeed * 2