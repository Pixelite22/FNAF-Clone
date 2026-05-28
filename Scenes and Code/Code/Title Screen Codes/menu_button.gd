extends Button

@onready var new_game: Button = $"."
@onready var continuebutton: Button = $"../Continue"
@onready var sixth_night: Button = $"../6th Night"
@onready var quit_game: Button = $"../Quit Game"

@onready var night_label: Label = $"../Continue/Night Label"

@onready var arrow: Label = $"../Arrow"
@onready var button_click: AudioStreamPlayer2D = $"../Button Click"
@onready var newspaper: TextureRect = $"../Newspaper"

var loading := false

func _ready() -> void:
	#Connect the needed signals to the correct functions
	connect("pressed", buttonPressed)
	connect("mouse_entered", mouseEntered)
	connect("mouse_exited", mouseExited)

func mouseEntered():
	#If the loading flag isn't true
	if not loading:
		#And the arrow position on the y axis isn't the same as the current position on the y axis
		if arrow.position.y != position.y:
			button_click.play() #Play the button_click sound
		arrow.position.y = position.y #set the arrow's position to the current position
		if self == continuebutton:
			night_label.show()
		else:
			night_label.hide()

func mouseExited():
	pass

func buttonPressed():
	loading = true #set loading to true
	match self.name: #and match the name of the current node to the following names
		"New Game": #if this is the new game button
			if arrow.position.y == new_game.position.y: #and the arrow is in the right spot
				await tween_paper() #wait for the tween_paper function to finish
				start_game() #and then start the game
			else: #otherwise pass
				pass
		"Continue": #if this is the continue button
			if arrow.position.y == new_game.position.y: #and the arrow is pointing to it
				print("Continue Selected!") #print placeholder message
			else:
				pass
		"6th Night":
			if arrow.position.y == new_game.position.y:
				print("6th Night Selected")
		"Quit Game": 
			if arrow.position.y == new_game.position.y:
				print("Quit Game Seleceted!")
				get_tree().quit() #close game
			else:
				pass

#Function to make the newspaper screen appear and disappear
func tween_paper():
	var tween = create_tween()
	
	#create and wait to finish a tween that tweens the alpha of the newspaper node
	await tween.tween_property(newspaper, "modulate:a", 1.0, 2.0).finished
	#then kill that tween to avoid errors
	tween.kill()
	#wait 5 seconds, allowing the paper to be read
	await get_tree().create_timer(5.0).timeout
	
	var tween2 = create_tween()
	
	#then repeat the first tween, but instead, fade the paper to black instead of fading the paper in
	await tween2.tween_property(newspaper, "modulate", Color.BLACK, 2.0).finished
	
	#then finally return the function
	return

func start_game():
	#change the scene to the game's start night screen, as this i swhere the game starts
	get_tree().change_scene_to_file("res://Scenes and Code/Scenes/night_start_screen.tscn")
