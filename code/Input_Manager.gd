extends Node3D

enum InputMode { PLAYING, LOCKPICKING, END_GAME_PANEL }
    
var input_mode: InputMode = InputMode.PLAYING;

func _input(event: InputEvent):
    pass

func set_input_mode(new_mode: InputMode):
    input_mode = new_mode
    
func is_playing_mode() -> bool:
    return input_mode == InputMode.PLAYING
