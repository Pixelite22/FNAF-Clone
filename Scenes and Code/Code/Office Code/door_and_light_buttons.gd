extends AnimatedSprite2D

var door_pressed : bool = false
var light_pressed : bool = false
var not_working : bool = false

signal door_change(door_state, name_of_switch)
signal lights_on(is_it)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in get_children(): #For all the buttons in the children of this node
		if "Door" in button.name: #If door is in the button name, 
			button.connect("pressed", door_button_pressed) #connect pressed to the door button function
		elif "Light" in button.name: #But if light is in the button name, 
			button.connect("pressed", light_button_pressed) #Connect the pressed signal to the light button function

func disconnect_door_button():
	for button in get_children():
		if button.has_signal("pressed"):
			if button.is_connected("pressed", door_button_pressed):
				button.disconnect("pressed", door_button_pressed)
				button.connect("pressed", door_click)
			elif button.is_connected("pressed", light_button_pressed):
				button.disconnect("pressed", light_button_pressed)
				button.connect("pressed", door_click)
			else:
				pass
	
	not_working = true

func door_no_more():
	for button in get_children():
		if button is Button:
			if button.is_connected("pressed", door_button_pressed):
				button.disconnect("pressed", door_button_pressed)
			if button.is_connected("pressed", door_click):
				button.disconnect("pressed", door_click)


func door_click():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.play()
	#enter door click sound here

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#Handles the sprite for the light and door switch
func light_switch_sprite():
	var frame_number #define a variable for the frame number
	var press_check = [door_pressed, light_pressed] #Define an array containing the door and light pressed variables
	if not_working:
		press_check[0] = false
	match press_check: #Match this array to the following possible states it can be in
		[false, false]: #If both the door and light aren't pressed
			frame_number = 0 #set frame 0
		[true, false]: #If the door is pressed but the light isn't
			frame_number = 1 #set frame 1
		[false, true]: #If the door isn't pressed but the light is
			frame_number = 2 #set frame 2
		[true, true]: #If both are pressed
			frame_number = 3 #set frame 3
	
	return frame_number #Return the frame number set

#Door function
func door_button_pressed():
	if not_working:
		print("Door Closure failed")
		return
	
	if not door_pressed: #If the door is currently not pressed
		door_pressed = true #set it to pressed
	elif door_pressed: #But if it is pressed
		door_pressed = false #set it to not pressed
	
	#Emit the door change signal with check of if the door is pressed and the name of the node sending that check
	door_change.emit(door_pressed, self.name)
	
	#Set the frame of the current door and light switch to the proper sprite
	frame = light_switch_sprite()

#Essentially the same function as above but with small changes to handle the light logic instead of the door logic
func light_button_pressed():
	#Same boolean swap as door
	if not light_pressed:
		light_pressed = true
	elif light_pressed:
		light_pressed = false
	
	#Same call to the light switch sprite to update it correctly
	frame = light_switch_sprite()
	
	#Emit the lights_on signal with the state of whether or not the light is pressed
	lights_on.emit(light_pressed)
