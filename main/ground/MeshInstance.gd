extends Spatial
export var pos: Vector2
signal unit_placed(pos)

var has_box = false

func _on_StaticBody_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		if (!has_box):
			emit_signal("unit_placed", pos)

func _on_StaticBody_mouse_entered():
	var new_material = SpatialMaterial.new()
	new_material.albedo_color = Color('bdbbba')
	var material = self.get_child(0).set_surface_material(0, new_material)


func _on_StaticBody_mouse_exited():
	var new_material = SpatialMaterial.new()
	new_material.albedo_color = Color(1,1,1)
	var material = self.get_child(0).set_surface_material(0, new_material)

func create_box(unit):
	var box = CSGBox.new()
	var material = SpatialMaterial.new()
	material.albedo_color = unit.color
	box.material = material
	box.height = 0
	self.add_child(box)
	has_box = true
	grow_box(unit.height)

func grow_new_box(unit):
	create_box(unit)

func grow_box(height):
	height *= 2
	var box = get_child(1)
	if(has_box): 
		box.translate(Vector3(0, -box.height/2, 0))
		box.translate(Vector3(0, height/2, 0))
		box.height = height

func remove_box():
	self.remove_child(get_child(1))
	has_box = false

func get_height():
	var box = get_child(1)
	return box.height / 2
