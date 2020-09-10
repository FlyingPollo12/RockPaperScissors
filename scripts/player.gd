extends Node2D

#Images
var noSelect = preload("res://assets/images/noSelect.png")
var Rock = preload("res://assets/images/rock.png")
var Paper = preload("res://assets/images/paper.png")
var Scissors = preload("res://assets/images/scissors.png")

var selected = "0"
var funcStart
var myTimer


func _ready():
	myTimer = Timer.new()
	myTimer.connect("timeout", self, "_myTimer_timeout")
	add_child(myTimer)
	funcStart = startRound()


func startRound():
	#PRE ROUND
	myTimer.set_wait_time(2)
	myTimer.set_one_shot(true)
	myTimer.start()
	
	#print("before yield")
	yield()
	#print("after yield")
	
	#SELECTION PHASE
	_on_select("0") #clear previous selection
	$opponent.texture = noSelect
	$timer/timerObj.set_wait_time(4)
	$timer/timerObj.set_one_shot(true)
	$timer/timerObj.start()


remote func answer(select):
	print("answer()")
	print("  selected: " + selected)
	print("  opponent: " + select)
	
	#show opponent answer
	match select:
		"0":
			print("texture: noselect")
			$opponent.texture = noSelect
		"Rock":
			print("texture: Rock")
			$opponent.texture = Rock
		"Paper":
			print("texture: Paper")
			$opponent.texture = Paper
		"Scissors":
			print("texture: Scissors")
			$opponent.texture = Scissors
	
	#adjust score
	if select == "0":
		print("opponent did not select!")
		var x = $scoreBoard/p1score.text
		$scoreBoard/p1score.text = str(int(x) + 1)
		checkEndGame()
		return
	match selected:
		"0":
			var x = $scoreBoard/p2score.text
			$scoreBoard/p2score.text = str(int(x) + 1)
			checkEndGame()
		"Rock":
			match select:
				"Rock":
					checkEndGame()
				"Paper":
					var x = $scoreBoard/p2score.text
					$scoreBoard/p2score.text = str(int(x) + 1)
					checkEndGame()
				"Scissors":
					var x = $scoreBoard/p1score.text
					$scoreBoard/p1score.text = str(int(x) + 1)
					checkEndGame()
		"Paper":
			match select:
				"Rock":
					var x = $scoreBoard/p1score.text
					$scoreBoard/p1score.text = str(int(x) + 1)
					checkEndGame()
				"Paper":
					checkEndGame()
				"Scissors":
					var x = $scoreBoard/p2score.text
					$scoreBoard/p2score.text = str(int(x) + 1)
					checkEndGame()
		"Scissors":
			match select:
				"Rock":
					var x = $scoreBoard/p2score.text
					$scoreBoard/p2score.text = str(int(x) + 1)
					checkEndGame()
				"Paper":
					var x = $scoreBoard/p1score.text
					$scoreBoard/p1score.text = str(int(x) + 1)
					checkEndGame()
				"Scissors":
					checkEndGame()


func _process(delta):
	$timer.text = str(int($timer/timerObj.time_left))


func _on_select(name):
	$Rock/selected.visible = false
	$Paper/selected.visible = false
	$Scissors/selected.visible = false
	if name == "Rock":
		$Rock/selected.visible = true
	elif name == "Paper":
		$Paper/selected.visible = true
	elif name == "Scissors":
		$Scissors/selected.visible = true
	
	selected = name


func _myTimer_timeout():
	funcStart.resume()


func _on_timerObj_timeout():
	print("SELECTED " + selected)
	rpc("answer", selected)


func checkEndGame():
	funcStart = startRound()
