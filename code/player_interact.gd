extends Node3D

@export var player_controller: Node3D

signal show_interact_sprite(show: bool)
signal show_dialogue_panel(text: String)
signal hide_dialogue_panel()
signal hide_follow_sprite()
signal show_lockpicking_sprites(show: bool)

var interact_button_sprite: Sprite2D
var can_pickup_rings: bool
var can_pick_locks: bool
var currently_interacting: bool
var has_npc_following: bool
var has_nearby_door: bool

var npc_storage: Array[NPC_Interaction_Data]
var npc_interacting_with: CharacterBody3D
var npc_following: CharacterBody3D
var door_in_range: Node3D

var rings_holder: StaticBody3D
var lock_pick_holder: StaticBody3D

func _ready():
    rings_holder = get_tree().get_first_node_in_group("rings")
    lock_pick_holder = get_tree().get_first_node_in_group("lock")

func entered_npc_trigger(npc: CharacterBody3D, text: String):
    npc_storage.append(NPC_Interaction_Data.new(text, npc))
    show_interact_sprite.emit(can_interact_with_npc())

func left_npc_trigger(npc: CharacterBody3D, text: String):
    if currently_interacting:
        npc_interacting_with.player_stops_interacting()
    var data_to_erase_index = npc_storage.bsearch(NPC_Interaction_Data.new(text, npc))
    npc_storage.remove_at(data_to_erase_index)
    show_interact_sprite.emit(false)
    hide_dialogue_panel.emit()
    currently_interacting = false
    if not has_npc_following:
        hide_follow_sprite.emit()
  
func entered_lock_pick_trigger():
    show_interact_sprite.emit(true)
    can_pick_locks = true
    
func left_lock_pick_trigger():
    show_interact_sprite.emit(false)
    can_pick_locks = false

func entered_rings_trigger():
    can_pickup_rings = true
    show_interact_sprite.emit(true)
    
func left_rings_trigger():
    can_pickup_rings = false
    show_interact_sprite.emit(false)
    
func entered_door_trigger(door: Node3D):
    door_in_range = door
    has_nearby_door = true
    show_interact_sprite.emit(true)

func left_door_trigger():
    has_nearby_door = false
    show_interact_sprite.emit(false)
    
func can_interact_with_npc() -> bool:
    return npc_storage.size() > 0 && not has_npc_following && not currently_interacting

func _input(event: InputEvent):
    if event.is_action_pressed("Interact") and can_interact_with_npc():
        player_controller.player_has_interacted()
        show_dialogue_panel.emit(get_closest_npc_data().talk_text)
        get_closest_npc_data().npc_body.player_interacts_with_npc()
        npc_interacting_with = get_closest_npc_data().npc_body
        currently_interacting = true
    elif event.is_action_pressed("Interact") and can_pickup_rings and rings_holder.can_be_picked_up:
        #todo emit a special sound for picking something up?
        WinManager.player_obtained_ring()
        can_pickup_rings = false
        show_interact_sprite.emit(false)
    elif event.is_action_pressed("Interact") and can_pick_locks and lock_pick_holder.can_be_unlocked:
        if InputManager.is_playing_mode():
            lock_pick_holder.start_lock_pick_mini_game()
            show_interact_sprite.emit(false)
            show_lockpicking_sprites.emit(true)
    elif event.is_action_pressed("Interact") and has_nearby_door and InputManager.is_playing_mode():
        door_in_range.interact_with_door()
        
    if event.is_action_pressed("Follow"):
        if currently_interacting && not has_npc_following:
            #tell npc to start following
            hide_dialogue_panel.emit()
            has_npc_following = true
            npc_following = npc_interacting_with
            npc_following.start_following_player()
            
        elif has_npc_following:
            # tell npc to stop following
            has_npc_following = false
            npc_following.stop_following_player()
            hide_follow_sprite.emit()
            
func get_closest_npc_data() -> NPC_Interaction_Data:
    if not can_interact_with_npc():
        print("no npcs!")
        return null
    
    var closest_npc_data: NPC_Interaction_Data
    var shortest_distance: float = 99999
    
    for i in npc_storage.size():
        var distance = global_position.distance_to(npc_storage.get(i).npc_body.global_position)
        if distance <= shortest_distance:
            shortest_distance = distance
            closest_npc_data = npc_storage.get(i)
        
    return closest_npc_data
