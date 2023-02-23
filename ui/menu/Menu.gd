extends Control


func _ready():
	pass # Replace with function body.


func _on_StartButton_pressed():
	get_tree().change_scene("res://main/Main.tscn")


func _on_OptionsButton_pressed():
	print('move to options')


func _on_QuitButton_pressed():
	get_tree().quit()
