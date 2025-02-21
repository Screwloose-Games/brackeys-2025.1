extends Node

enum SoundCategory {
	PLAYER,
	MUSIC,
	ENVIRONMENT,
	FEEDBACK
}

enum AudioBusType {
	MASTER, 
	SFX, 
	MUSIC, 
	ENVIRONMENT
}

enum MusicTransition {
	TO_ACTION,
	TO_RELAX,
	TO_SNEAK,
}

@export_range(0.0, 1.0) var master_volume: float = 0.8
@export_range(0.0, 1.0) var sfx_volume: float = 0.8
@export_range(0.0, 1.0) var music_volume: float = 0.8
@export var fade_time: float = 1.0

@onready var player_sounds: AudioStreamPlayer = $PlayerSounds
@onready var environment_sounds: AudioStreamPlayer = $EnvironmentSounds
@onready var feedback_sounds: AudioStreamPlayer = $FeedbackSounds

@onready var sneak_music: AudioStreamPlayer = $SneakMusic
@onready var action_music: AudioStreamPlayer = $ActionMusic
@onready var relaxing_music: AudioStreamPlayer = $RelaxingMusic

var audio_players: Dictionary = {}

var sfx_dictionary: Dictionary = {
	# Player
	"player_jumped": {
		"stream": [
			preload("res://common/audio/sfx/player/jump/Jump1.wav"), 
			preload("res://common/audio/sfx/player/jump/jump2.wav"), 
			preload("res://common/audio/sfx/player/jump/jump3.wav")
		],
		"category": SoundCategory.PLAYER
	},
	"slide": {
		"stream": preload("res://common/audio/sfx/player/slide/Swoosh4.wav"),
		"category": SoundCategory.PLAYER
	},
	"player_started_walking": {
		"stream": preload("res://common/audio/sfx/player/walk/Walking Loop - Flooring.wav"),
		"category": SoundCategory.PLAYER
	},
	"player_sprinting": {
		"stream": preload("res://common/audio/sfx/player/walk/Running Loop - Flooring.wav"),
		"category": SoundCategory.PLAYER
	},
	# 
	"success": {
		"stream": preload("res://common/audio/sfx/sound_success.wav"),
		"category": SoundCategory.FEEDBACK
	},
	"fail": {
		"stream": preload("res://common/audio/sfx/sound_fail_sting.wav"),
		"category": SoundCategory.FEEDBACK
	}
}

func _ready() -> void:
	audio_players = {
		SoundCategory.PLAYER: player_sounds,
		SoundCategory.ENVIRONMENT: environment_sounds,
		SoundCategory.FEEDBACK: feedback_sounds
	}
	
	call_deferred("initialize_volume")
	_change_music(MusicTransition.TO_RELAX)

func initialize_volume():
	set_volume(AudioBusType.MASTER, master_volume)
	set_volume(AudioBusType.SFX, sfx_volume)
	set_volume(AudioBusType.MUSIC, music_volume)

func connect_audio_signals(node: Node):
	if node.has_signal("player_stopped_walking"):
		if !node.is_connected("player_stopped_walking", _stop_player_sound):
				node.connect("player_stopped_walking", _stop_player_sound)
				
	for sfx_request in sfx_dictionary.keys():
		if node.has_signal(sfx_request):
			if !node.is_connected(sfx_request, _play_sound):
				node.connect(sfx_request, _play_sound.bind(sfx_request))
				print("Signal: ", sfx_request, " connected")
				
		if node.has_signal("music_change"):
			if !node.is_connected("music_change", _change_music):
				node.connect("music_change", _change_music)
	
				
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
	
	
	if sfx_request == "player_sprinting":
		if (audio_player.stream == sfx_dictionary["player_sprinting"]["stream"] 
		&& audio_player.playing):
			return
		_change_music(MusicTransition.TO_ACTION)
	
	audio_player.stream = stream_path
	
	if !audio_player.stream:
		print(sfx_request, " does not exist")
		return
	else:
		audio_player.play()
		print("Playing ",audio_player.stream)

func _change_music(music_request: MusicTransition):
	var target_music: AudioStreamPlayer
	
	match music_request:
		MusicTransition.TO_ACTION:
			target_music = action_music
		MusicTransition.TO_RELAX:
			target_music = relaxing_music
		MusicTransition.TO_SNEAK:
			target_music = sneak_music
		_:
			return

	for music_player in [sneak_music, action_music, relaxing_music]:
		if music_player != target_music and music_player.playing:
			fade_out(music_player)

	fade_in(target_music)

func fade_out(audio_player: AudioStreamPlayer):
	if audio_player.playing:
		var tween = get_tree().create_tween()
		tween.tween_property(audio_player, "volume_db", -40, fade_time)

func fade_in(audio_player: AudioStreamPlayer):
	if !audio_player.playing:
		audio_player.volume_db = -40
		audio_player.play()
		var tween = get_tree().create_tween()
		tween.tween_property(audio_player, "volume_db", 0, fade_time)
		
func _stop_player_sound():
	player_sounds.stop()
	_change_music(MusicTransition.TO_SNEAK)

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
