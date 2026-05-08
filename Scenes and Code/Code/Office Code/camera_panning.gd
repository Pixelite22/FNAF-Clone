extends Area2D

@export var pan_speed : float = 200	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", mouse_entered)
	connect("mouse_exited", mouse_exited)

func mouse_entered():
	if "Left" in self.name:
		Global.office_pan -= pan_speed
	else:
		Global.office_pan += pan_speed

func mouse_exited():
	if "Left" in self.name:
		Global.office_pan += pan_speed
	else:
		Global.office_pan -= pan_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
