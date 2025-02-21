extends Control

signal player_jumped()
signal player_landed()
signal player_started_walking()
signal player_stopped_walking()
signal player_sprinting()
signal player_interacted()
signal music_change(track)
signal intensify_music

@onready var music_volume: HSlider = $VBoxContainer/MusicVol
@onready var sfx_volume: HSlider = $VBoxContainer/SFXVol

func _ready() -> void:
	AudioManager.connect_audio_signals(self)
	music_volume.value = AudioServer.get_bus_volume_linear(2)
	sfx_volume.value = AudioServer.get_bus_volume_linear(1)
	

func _on_walk_pressed() -> void:
	player_started_walking.emit()

func _on_run_pressed() -> void:
	player_sprinting.emit()

func _on_jump_pressed() -> void:
	player_jumped.emit()

func _on_slide_pressed() -> void:
	pass

func _on_sneak_music_pressed() -> void:
	music_change.emit("sneak")

func _on_action_music_pressed() -> void:
	music_change.emit("action")


func _on_music_vol_value_changed(value: float) -> void:
	AudioManager.set_volume(AudioManager.AudioBusType.MUSIC, value)


func _on_sfx_vol_value_changed(value: float) -> void:
	AudioManager.set_volume(AudioManager.AudioBusType.SFX, value)

func _on_relaxing_music_pressed() -> void:
	music_change.emit("light")
