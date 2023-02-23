extends Control

func _ready():
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	if err != OK:
		set_default_config()
		
func _on_StartButton_pressed():
	get_tree().change_scene("res://main/Main.tscn")


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://ui/options/Options.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()

func set_default_config():
	var config = ConfigFile.new()

	config.set_value("Player1", "audio_enabled", true)
	config.set_value("Player1", "time_delay", 0.3)
	config.set_value("Player1", "volume", 0)

	config.save("user://config.cfg")
