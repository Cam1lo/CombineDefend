extends HBoxContainer

var SelectedUnit = load('res://main/inventory/SelectedUnit.tscn')
var UpcommingUnit = load('res://main/inventory/UpcommingUnit.tscn')

func inventory_update(units):
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
