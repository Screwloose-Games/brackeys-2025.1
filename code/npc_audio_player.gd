extends AudioStreamPlayer3D
class_name NpcAudioPlayer

enum NpcSounds {
	INTERACT,
	WALK,
	UNDERSTANDING,
	CRYING,
	PAIN,
	DISAGREE,
	SLY_LAUGH,
	MMM,
	DISCOVERY,
	YAWN,
	HEHEH,
	QUESTION,
	INTEREST
}

@export var npc_root: CharacterBody3D

var masc_sound_dictionary: Dictionary = {
	NpcSounds.INTERACT: {
		"stream": "res://scenes/npc/guest_masc/sounds/masc_interact_randomizer.tres",
	},
	NpcSounds.WALK: {
		"stream": "res://common/audio/sfx/npc/npc_footsteps.tres",
	},
	NpcSounds.UNDERSTANDING: {
		"stream": "res://scenes/npc/best_man/sounds/adult_masc_uh_huh.wav",
	},
	NpcSounds.CRYING: {
		"stream": "res://scenes/npc/groom/sounds/adult_masc_crying.wav",
	},
	NpcSounds.PAIN: {
		"stream": "res://scenes/npc/groom/sounds/adult_masc_pain.wav",
	},
	NpcSounds.DISAGREE: {
		"stream": "res://scenes/npc/technician/sounds/adult_masc_grumpy.wav",
	},
	NpcSounds.SLY_LAUGH: {
		"stream": "res://scenes/npc/guest_masc/sounds/adult_masc_sly_laugh.wav",
	},
	NpcSounds.MMM: {
		"stream": "res://scenes/npc/technician/sounds/adult_masc_indeed.wav",
	},
	NpcSounds.DISCOVERY: {
		"stream": "res://scenes/npc/uncle_bob/sounds/adult_masc_discovery_ooo.wav",
	},
	NpcSounds.YAWN: {
		"stream": "res://scenes/npc/guest_masc/sounds/adult_masc_yawn.wav",
	},
	NpcSounds.HEHEH: {
		"stream": "res://scenes/npc/uncle_bob/sounds/adult_masc_heheh.wav",
	},
	NpcSounds.INTEREST: {
		"stream": "res://scenes/npc/uncle_bob/sounds/adult_masc_interested_oh.wav",
	},
	NpcSounds.QUESTION: {
		"stream": "res://scenes/npc/uncle_bob/sounds/adult_masc_questioning_huh.wav",
	},
}

var femme_sound_dictionary: Dictionary = {
	NpcSounds.INTERACT: {
		"stream": "res://scenes/npc/guest_femme/sounds/femme_interact_randomizer.tres",
	},
	NpcSounds.WALK: {
		"stream": "res://common/audio/sfx/npc/npc_footsteps.tres",
	},
	NpcSounds.UNDERSTANDING: {
		"stream": "res://scenes/npc/guest_femme/sounds/adult_femme_understanding.wav",
	},
	NpcSounds.CRYING: {
		"stream": "res://scenes/npc/bride/sounds/adult_femme_crying.wav",
	},
	NpcSounds.PAIN: {
		"stream": "res://scenes/npc/guest_femme/sounds/adult_femme_injured.wav",
	},
	NpcSounds.DISAGREE: {
		"stream": "res://scenes/npc/bride/sounds/adult_femme_disagree.wav",
	},
	NpcSounds.SLY_LAUGH: {
		"stream": "res://scenes/npc/guest_femme/sounds/adult_femme_sly_laugh.wav",
	},
	NpcSounds.MMM: {
		"stream": "res://scenes/npc/bride/sounds/adult_femme_mmm.wav",
	},
	NpcSounds.DISCOVERY: {
		"stream": "res://scenes/npc/guest_femme/sounds/adult_femme_discovery.wav",
	},
	NpcSounds.YAWN: {
		"stream": "res://scenes/npc/guest_femme/sounds/adult_femme_yawn.wav",
	},
	NpcSounds.HEHEH: {
		"stream": "res://scenes/npc/guest_femme/sounds/adult_femme_chuckle.wav",
	},
	NpcSounds.QUESTION: {
		"stream": "res://scenes/npc/woman_in_white/sounds/adult_femme_question.wav",
	},
	NpcSounds.INTEREST: {
		"stream": "res://scenes/npc/guest_femme/sounds/adult_femme_interested.wav",
	},
}

var used_dictionary: Dictionary = {}

func _get_dictionary() -> Dictionary:
	if npc_root.is_masc:
		return masc_sound_dictionary 
	else: 
		return femme_sound_dictionary

func play_sound(sound: NpcSounds) -> void:
	var used_dictionary = _get_dictionary()
	if sound in used_dictionary:
		stream = load(used_dictionary[sound].get("stream"))
		play()
