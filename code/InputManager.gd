extends Node

enum InputMode { Playing }
	
var inputMode: InputMode = InputMode.Playing;

func _input(_event: InputEvent):
	pass
	
func setInputMode(newMode: InputMode):
	inputMode = newMode
