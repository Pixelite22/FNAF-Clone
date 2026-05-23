extends Area2D

@export var pan_speed : float = 200	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connect the mouse entered and exited signals for the camera panning collision
	connect("mouse_entered", mouse_entered)
	connect("mouse_exited", mouse_exited)

func mouse_entered():
	if not Global.camera_menu_active:
		if "Left" in self.name: #If the word Left is in the name of the node accessing this script
			Global.office_pan -= pan_speed #Subtract whatever the pan speed is from the office pan global stat
		else: #Otherwise, meaning it has Right in it's name
			Global.office_pan += pan_speed #add the pan speed

func mouse_exited():
	if not Global.camera_menu_active:
		if "Left" in self.name: #If the mouse exited a left collision
			Global.office_pan += pan_speed #Add the pan speed back
		else: #otherwise
			Global.office_pan -= pan_speed #Subtract it

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
