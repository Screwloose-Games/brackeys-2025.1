extends Node3D

enum InputMode { PLAYING, LOCKPICKING }
    
var input_mode: InputMode = InputMode.PLAYING;

func _input(event: InputEvent):
    pass

func set_input_mode(new_mode: InputMode):
    input_mode = new_mode
