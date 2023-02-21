extends Position3D

onready var AP = get_node('../AnimationPlayer')

var camera_controlled: bool = false
var mouse_pos: Vector2 

func _process(delta):
	if Input.is_action_just_pressed("camera_control"):
		camera_controlled = true
		mouse_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_released("camera_control"):
		camera_controlled = false
	
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

func _unhandled_input(event):
	if event is InputEventMouseMotion and camera_controlled:
		var diff_x = mouse_pos.x - event.position.x
		var diff_y = event.position.y - mouse_pos.y

		#CameraPivot Cordenates are inverted
		if(self.rotation_degrees.x + diff_y > 45 and self.rotation_degrees.x + diff_y < 120):
			self.rotation_degrees.x += diff_y
		self.rotation_degrees.y += diff_x
		mouse_pos = event.position
