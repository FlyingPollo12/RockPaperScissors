extends Area2D


signal _pressed(name)


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")



func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_action_pressed("ui_select"):
			print("clicked " + get_parent().get_name())
			emit_signal("_pressed", get_parent().get_name())
