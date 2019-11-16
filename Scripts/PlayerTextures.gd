extends Node2D

onready var animations = [$Arms, $WheelChair/Wheel]

func _setDirection(direction):
	if direction < 0:
		scale.x = -1
	elif direction > 0:
		scale.x = 1
	
func _setRolling(isRolling):
	for animation in animations:
		var animSprite : AnimatedSprite = animation
		animSprite._set_playing(isRolling)