extends Control

onready var slider = $VBoxContainer/MasterVolumeOption/MasterVolumeSlider
onready var config = get_config()

func _ready():
	slider.value = config.volume


func _on_MasterVolumeSlider_value_changed(value):
	config.volume = value

func _on_SaveExitButton_pressed():
	save_config()
	get_tree().change_scene("res://ui/menu/Menu.tscn")


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

func save_config():
	var data = config
	var config = ConfigFile.new()
	
	for key in data:
		config.set_value('Player1', key, data[key])

	config.save("user://config.cfg")
