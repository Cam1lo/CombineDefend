extends CanvasLayer

onready var config = get_config()

const INITIAL_INVENTORY_SIZE = 4
const INITIAL_UNITS_ON_GRID = 10

onready var GridController = $GridController
onready var Inventory = $Inventory 
onready var BackgroundMusic = $BackgroundMusic

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), config.volume)

	GridController.init()
	Inventory.generate_units(INITIAL_INVENTORY_SIZE)
	set_initial_units(INITIAL_UNITS_ON_GRID)	
	Inventory.inventory_update()
	BackgroundMusic.init(config)
	
func set_initial_units(amount):
	var previous_config_audio = config.audio_enabled
	var previous_config_time = config.time_delay
	
	config.audio_enabled = false
	config.time_delay = 0
	
	for i in range(0, amount):
		var random_pos = Vector2(randi() % 5, randi() % 5)
		if typeof(GridController.grid[random_pos.x][random_pos.y]) == TYPE_INT:
			GridController.grid[random_pos.x][random_pos.y] = Inventory.get_selected_unit()
			place_unit(random_pos, Inventory.get_selected_unit())
			GridController.check_grid()
			Inventory.pop_queue()
			
	yield(get_tree().create_timer(0.1), "timeout")	
	config.audio_enabled = previous_config_audio
	config.time_delay = previous_config_time

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

func read_config():
	var file = File.new()
	file.open("res://config.res", File.READ)
	var read_dict = str2var(file.get_as_text())
	file.close()
	return read_dict

func get_config():
	var data = {}
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://config.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return

	# Iterate over all sections.
	for key in config.get_section_keys('Player1'):
		data[key] = config.get_value('Player1', key)
	
	return data
