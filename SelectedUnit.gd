extends Control

export var color: Color

func _ready():
	$ColorRect.color = color
