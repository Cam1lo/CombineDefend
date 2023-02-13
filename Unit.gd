class_name Unit extends Resource
var color
var height
var sibling_to_grow
	
func _init(color, height, sibling_to_grow):
	self.color = color
	self.height = height
	self.sibling_to_grow = sibling_to_grow
