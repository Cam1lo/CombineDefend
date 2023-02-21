extends HBoxContainer
var UnitClass = load('res://models/Unit.gd')
var SelectedUnit = load('res://main/inventory/SelectedUnit.tscn')
var UpcommingUnit = load('res://main/inventory/UpcommingUnit.tscn')
var units = []
var turns = 0
var red = Color('e63946')
var blue = Color('457b9d')
var green = Color('2a9d8f')
var yellow = Color('fcbf49')
var color_dict = [red, blue, green, yellow]

func inventory_update():
	delete_children(self)
	var selectedUnit = SelectedUnit.instance()
	selectedUnit.color = units[0].color
	self.add_child(selectedUnit)
	
	for i in range(1, units.size()):
		var upcommingUnit = UpcommingUnit.instance()
		upcommingUnit.color = units[i].color
		self.add_child(upcommingUnit)
	
func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)

func get_selected_unit():
	return units[0]

func pop_queue():
	units.pop_front()
	queue_random_unit()
	inventory_update()

func generate_units(size):
	for i in range(0, size):
		queue_random_unit()

func queue_random_unit():
	var random_color = color_dict[randi() % color_dict.size() - 1]
	turns += 1
	units.append(UnitClass.new(random_color, 1, turns))
