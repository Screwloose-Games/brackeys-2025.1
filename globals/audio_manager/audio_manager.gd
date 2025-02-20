extends Node

enum SoundCategory {
	PLAYER,
	MUSIC,
	ENVIRONMENT,
	UI
}

enum AudioBusType {
	MASTER, 
	SFX, 
	MUSIC, 
	ENVIRONMENT
}

@onready var player_sounds: AudioStreamPlayer = $PlayerSounds
@onready var music: AudioStreamPlayer = $Music
@onready var environment_sounds: AudioStreamPlayer = $EnvironmentSounds
@onready var ui_sounds: AudioStreamPlayer = $UISounds
@onready var music_base: AudioStreamPlayer = $MusicBase
@onready var intensify_timer: Timer = $Music/IntensifyTimer


var audio_players: Dictionary = {}

var sfx_dictionary: Dictionary = {
	"jump": {
		"stream": [
			preload("res://common/audio/sfx/player/jump/jump1.wav"), 
			preload("res://common/audio/sfx/player/jump/jump2.wav"), 
			preload("res://common/audio/sfx/player/jump/jump3.wav")
		],
		"category": SoundCategory.PLAYER
	},
	"slide": {
		"stream": preload("res://common/audio/sfx/player/slide/Swoosh4.wav"),
		"category": SoundCategory.PLAYER
	},
	"walk": {
		"stream": preload("res://common/audio/sfx/player/walk/Walking Loop - Flooring.wav"),
		"category": SoundCategory.PLAYER
	},
	"run": {
		"stream": preload("res://common/audio/sfx/player/walk/Running Loop - Flooring.wav"),
		"category": SoundCategory.PLAYER
	}
	
	
}

var music_dictionary: Dictionary = {
	"light": "PATH TO TRACK",
	"sneak": preload("res://common/audio/music/TEMPSneakTime.mp3"),
	"sneak_base": preload("res://common/audio/music/SneakTimeBase.mp3"),
	"action": preload("res://common/audio/music/TEMP-Rush.mp3"),
}

func _ready() -> void:
	audio_players = {
		SoundCategory.PLAYER: player_sounds,
		SoundCategory.MUSIC: music,
		SoundCategory.ENVIRONMENT: environment_sounds,
		SoundCategory.UI: ui_sounds
	}

func connect_audio_signals(node: Node):
	print(node," is being checked for signals")
	for sfx_request in sfx_dictionary.keys():
		if node.has_signal(sfx_request):
			if !node.is_connected(sfx_request, _play_sound):
				node.connect(sfx_request, _play_sound.bind(sfx_request))
		if node.has_signal("music_change"):
			if !node.is_connected("music_change", _play_music):
				node.connect("music_change", _play_music)
				print(node, " has grabbed the aux")
		if node.has_signal("intensify_music"):
			if !node.is_connected("intensify_music", _intensify_music):
				node.connect("intensify_music", _intensify_music)
				print(node, " has grabbed the aux")
				
	for child in node.get_children():
		if child is Node: #TODO decide a better class to check for
			connect_audio_signals(child)

func _play_sound(sfx_request):
	var sfx_data = sfx_dictionary[sfx_request]
	if !sfx_data:
		print(sfx_request, " does not exist")
		return
	
	var stream_path = sfx_data["stream"]
	if stream_path is Array:
		stream_path = stream_path[randi() % stream_path.size()]
	
	var category = sfx_data["category"]
	var audio_player = audio_players.get(category)
	if audio_player == null:
		print("Invalid category: ", category)
		return
	
	audio_player.stream = stream_path
	
	if !audio_player.stream:
		print(sfx_request, " does not exist")
		return
	else:
		audio_player.play()

func _play_music(music_request : String):
	var base_track = music_request + "_base"
	music.stream = music_dictionary[music_request]
	music_base.stream = music_dictionary[base_track]
	music.volume_linear = 0
	music.play()
	music_base.play()

func _intensify_music():
	intensify_timer.start()
	
	var tween = get_tree().create_tween()
	tween.tween_property(music, "volume_linear", 1.0, intensify_timer.wait_time)

func get_volume(bus: AudioBusType):
	match(bus):
		AudioBusType.MASTER:
			return AudioServer.get_bus_volume_db(0)
		AudioBusType.SFX:
			return AudioServer.get_bus_volume_db(1)
		AudioBusType.MUSIC:
			return AudioServer.get_bus_volume_db(2)
		AudioBusType.ENVIRONMENT:
			return AudioServer.get_bus_volume_db(3)
		_:
			return AudioServer.get_bus_volume_db(0)

func set_volume(bus, value: float):
	match(bus):
		AudioBusType.MASTER:
			AudioServer.set_bus_volume_db(0, linear_to_db(value))
		AudioBusType.SFX:
			AudioServer.set_bus_volume_db(1, linear_to_db(value))
		AudioBusType.MUSIC:
			AudioServer.set_bus_volume_db(2, linear_to_db(value))
		AudioBusType.ENVIRONMENT:
			AudioServer.set_bus_volume_db(3, linear_to_db(value))
		_:
			AudioServer.set_bus_volume_db(0, linear_to_db(value))
