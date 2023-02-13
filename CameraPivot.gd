extends Position3D

onready var AP = get_node('../AnimationPlayer')

func _process(delta):
	if Input.is_action_just_pressed("rotate_camera_left"):
		rotate_left()
	if Input.is_action_just_pressed("rotate_camera_right"):
		rotate_right()

func rotate_left():
	match int(ceil(rotation_degrees.y)):
		-45: 
			AP.play("l315to225")
		45:
			AP.play("l45to-45")
		135:
			AP.play("l135to45")
		225:
			AP.play("l225to135")
		315:
			AP.play("l315to225")
		405:
			AP.play("l45to-45")
		_:
			print(rotation_degrees.y)
			
func rotate_right():
	match int(ceil(rotation_degrees.y)):
		-45:
			AP.play("r135to225")
		45:
			AP.play("r45to135")
		135:
			AP.play("r135to225")
		225:
			AP.play("r225to315")
		315:
			AP.play("r315to405")
		405:
			AP.play("r45to135")
		_:
			print(rotation_degrees.y)
