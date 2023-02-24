extends Spatial


export var color: Color
export var height: int
export var age: int

func set_color(color):
	self.color = color
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$Box.material = material

func set_height(height):
	var previous_height = $Box.height
	var previous_pos = $Box.translation
	var animation = $AnimationPlayer.get_animation('grow')
	animation.track_insert_key(0, 0.0, previous_height)
	animation.track_insert_key(0, 0.3, height)
	animation.track_insert_key(1, 0, previous_pos)
	animation.track_insert_key(1, 0.3, Vector3(0, (height/2) - 1, 0))
	$AnimationPlayer.play("grow")
	self.height = height
	$Box.height = height

func play_intro_animation():
	$AnimationPlayer.play("intro")
	return $AnimationPlayer

func play_remove_animation(direction):
	var box = $Box
	match direction:
		'left':
			$AnimationPlayer.play("remove_left")
		'up':
			$AnimationPlayer.play("remove_up")
		'down':
			$AnimationPlayer.play("remove_down")
		'right':
			$AnimationPlayer.play("remove_right")
	
	return $AnimationPlayer
