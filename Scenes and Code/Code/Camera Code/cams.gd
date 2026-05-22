extends Node2D

@onready var blip_flash: AnimatedSprite2D = $"Blip Flash"
@onready var swap_sound: AudioStreamPlayer2D = $"Swap Sound"
@onready var location_names: AnimatedSprite2D = $"Location Names"
@onready var kitchen_text: Sprite2D = $"Kitchen Text"

var cam_to_locations: Dictionary = {
	#Key/Camera : Location
	"Cam 1A" : "BS",
	"Cam 1B" : "SS",
	"Cam 1C" : "DH",
	"Cam 2A" : "WH",
	"Cam 2B" : "WHC",
	"Cam 3" : "SC",
	"Cam 4A" : "EH",
	"Cam 4B" : "EHC",
	"Cam 5" : "Pirate Cove",
	"Cam 6" : "Kitchen", #This is the disabled camera and will need to be handled later
	"Cam 7" : "RR"
}

var starting_room = "SS"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children(): #loop through all the children of this node
		if "Cam" in child.name: #and if it has Cam in it's name
			child.get_child(0).connect("pressed", _on_button_pressed.bind(child)) #connect the button node on the child nodes button pressed signal to the correct function
			child.get_child(0).text = child.name.replace(" ", "\n").to_upper() #replace the name with an uppercase version of itself with a new line in place of the space
			if cam_to_locations[child.name] == starting_room: #and if the child name matches the starting room
				child.animation = "Selected" #select the animation for the blinking button
				child.play() #and play it
			else: #otherwise
				child.animation = "Unselected" #make sure the animation is set to unselected


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#when a camera button is pressed
func _on_button_pressed(button_pressed : AnimatedSprite2D):
	for child in get_children(): #loop through the children of this node
		if "Cam" in child.name: #and if the child has a Cam in it's name anywhere
			#unselect them all
			if child.animation != "Unselected": 
				child.animation = "Unselected"
	
	#then, for the passed pressed button, select it and play it's animation
	button_pressed.animation = "Selected"
	button_pressed.play()
	
	#Then play the blip flash to hide the cut and the sound to signal a cut is happening
	blip_flash.play()
	swap_sound.play()
	
	
	#Set the location name's animation to the animation that corresponds to the cam_to_location dictionary
	location_names.animation = cam_to_locations[button_pressed.name]
	#and then set the actual camera animations current cam to the correct location
	Global.current_cam = cam_to_locations[button_pressed.name]
	
	#Handle the kitchen text visibility
	if location_names.animation == "Kitchen":
		kitchen_text.show()
	else:
		kitchen_text.hide()


func _on_camera_view_animatronic_moved_active_cam() -> void:
	blip_flash.play()
