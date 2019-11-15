extends RigidBody2D

var speed : float = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
func _input(event):
	print("Input")
	print(Input.get_action_strength("ui_left"))