extends Node2D


var SERVER_PORT = 25565
var SERVER_IP = "localhost"
export var MAX_PLAYERS = 4


func _ready():
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("connected_to_server", self, "_connected_ok")


func _on_createServer_pressed():
	#initializing as a server, listening on the given port, with a given maximum number of peers:
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int($joinServer/serverPort.text), MAX_PLAYERS)
	print("creating server with port:"+$joinServer/serverPort.text)
	get_tree().network_peer = peer
	
	var lobbyScn = preload("res://Lobby.tscn")
	#add_child(lobbyScn.instance())
	get_tree().change_scene_to(lobbyScn)


func _on_joinServer_pressed():
	#Initializing as a client, connecting to a given IP and port:
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client($joinServer/serverIP.text, int($joinServer/serverPort.text))
	print("joining server with ip="+$joinServer/serverIP.text + " and port: " + $joinServer/serverPort.text)
	get_tree().network_peer = peer
	
	var lobbyScn = preload("res://Lobby.tscn")
	#add_child(lobbyScn.instance())
	get_tree().change_scene_to(lobbyScn)


func _connected_fail(id):
	print("player " + id + " could not connect")

func _connected_ok(id):
	print("player " + id + " connected_ok")


func _player_connected(id):
	print("Player"+str(id) + " connected")
	
	var playerlist = find_node("connectedPlayers", true, false)
	playerlist.add_text("Player"+str(id))
