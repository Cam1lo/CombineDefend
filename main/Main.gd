extends CanvasLayer

var config = {
	'audio_enabled': true
}

const INITIAL_INVENTORY_SIZE = 4
const INITIAL_UNITS_ON_GRID = 10

onready var GridController = $GridController
onready var Inventory = $Inventory 
onready var BackgroundMusic = $BackgroundMusic

func _ready():
	randomize()
	GridController.init()
	Inventory.generate_units(INITIAL_INVENTORY_SIZE)
	set_initial_units(INITIAL_UNITS_ON_GRID)	
	Inventory.inventory_update()
	BackgroundMusic.init(config)
	
func set_initial_units(amount):
	var was_audio_enabled = config.audio_enabled
	config.audio_enabled = false
	for i in range(0, amount):
		var random_pos = Vector2(randi() % 5, randi() % 5)
		if typeof(GridController.grid[random_pos.x][random_pos.y]) == TYPE_INT:
			GridController.grid[random_pos.x][random_pos.y] = Inventory.get_selected_unit()
			place_unit(random_pos, Inventory.get_selected_unit())
			GridController.check_grid()
			Inventory.pop_queue()
	config.audio_enabled = was_audio_enabled

func _on_Ground_unit_placed(pos):
	GridController.grid[pos.x][pos.y] = Inventory.get_selected_unit()
	place_unit(pos, Inventory.get_selected_unit())
	GridController.check_grid()
	Inventory.pop_queue()

func place_units_from_grid(grid: Array):
	for i in range(5):
		for j in range(5):
			if grid[i][j]:
				var pos = Vector2(i, j)
				place_unit(pos, grid[i][j])

func place_unit(pos, unit):
	$Ground.grow_new_tile(pos, unit)

