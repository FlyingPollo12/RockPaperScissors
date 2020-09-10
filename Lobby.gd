extends Node2D


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	var selfPeerID = get_tree().get_network_unique_id()
	$connectedPlayers.add_text("Player"+str(selfPeerID) + "(me)\n")

func _player_connected(id):
	print("Player"+str(id) + " connected")
	#var playerlist = find_node("connectedPlayers", true, false)
	$connectedPlayers.add_text("Player"+str(id) + "\n")


remotesync func loadGame():
	var selfPeerID = get_tree().get_network_unique_id()
	var playerscene = preload("res://player.tscn")
	playerscene.set_name(str(selfPeerID))
	get_tree().change_scene_to(playerscene)


remote func displaySelect(selection):
	pass


func _on_playButton_pressed():
	var selfID = get_tree().get_network_unique_id()
	if selfID == 1: #is server
		rpc("loadGame")
		
