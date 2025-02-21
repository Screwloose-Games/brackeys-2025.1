extends AudioStreamPlayer3D
class_name NpcAudioPlayer

@export var npc_root: CharacterBody3D

var masc_sound_dictionary: Dictionary = {
	"interact": {
		"stream": "res://scenes/npc/guest_masc/sounds/masc_interact_randomizer.tres",
	},
	"walk": {
		"stream": "res://common/audio/sfx/npc/npc_footsteps.tres",
	},
}

var femme_sound_dictionary: Dictionary = {
	"interact": {
		"stream": "res://scenes/npc/guest_femme/sounds/femme_interact_randomizer.tres",
	},
	"walk": {
		"stream": "res://common/audio/sfx/npc/npc_footsteps.tres",
	},
}

var used_dictionary: Dictionary = {}

func _ready() -> void:
	if npc_root.is_masc:
		used_dictionary = masc_sound_dictionary
	else:
		used_dictionary = femme_sound_dictionary
	for key in used_dictionary.keys():
		var stream_path = used_dictionary[key].get("stream", "")
		if stream_path != "":
			used_dictionary[key]["stream"] = load(stream_path)

func interact():
	stream = used_dictionary["interact"].get("stream")
	play()
