extends StaticBody3D

@export var npc_text: String 
var interaction_detection: Node3D

func _ready():
	interaction_detection = get_node("InteractionDetection")
	interaction_detection.set_text(npc_text)
