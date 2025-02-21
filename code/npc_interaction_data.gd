class_name NPC_Interaction_Data
extends Resource

var talk_text: String
var npc_body: CharacterBody3D

func _init(_talk_text: String = "", _npc_body: CharacterBody3D = null):
    talk_text = _talk_text
    npc_body = _npc_body
