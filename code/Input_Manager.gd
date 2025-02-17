extends Node3D

enum InputMode { PLAYING }
    
var input_mode: InputMode = InputMode.PLAYING;
    
func set_input_mode(new_mode: InputMode):
    input_mode = new_mode
