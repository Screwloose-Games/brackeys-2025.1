extends Node

@onready var sfx_player: AudioStreamPlayer = $SfxPlayer

var sfx_dictionary = {
	"jump": "PATH TO SOUND",
}

func connect_audio_signals(node: Node):
	print(node," is being checked for signals")
	for sfx_request in sfx_dictionary.keys():
		if node.has_signal(sfx_request):
			if !node.is_connected(sfx_request, _play_sound):
				node.connect(sfx_request, _play_sound.bind(sfx_request))
	for child in node.get_children():
		if child is Node: #TODO decide a better class to check for
			connect_audio_signals(child)
				
func _on_node_exited():
	pass

func _play_sound(sfx_request):
	sfx_player.stream = load(sfx_dictionary[sfx_request]) #TODO make these preloads
	if !sfx_player.stream:
		print(sfx_request," does not exist")
		return
	else:
		sfx_player.play()
