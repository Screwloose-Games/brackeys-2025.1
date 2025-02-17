extends Node

enum InputMode { PLAYING }
	
var input_mode: InputMode = InputMode.PLAYING;

func _input(_event: InputEvent):
	pass
	
func set_input_mode(new_mode: InputMode):
	input_mode = new_mode
