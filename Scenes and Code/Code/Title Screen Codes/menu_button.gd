extends Button

@onready var new_game: Button = $"."
@onready var continuebutton: Button = $"../Continue"
@onready var quit_game: Button = $"../Quit Game"

@onready var arrow: Label = $"../Arrow"
@onready var button_click: AudioStreamPlayer2D = $"../Button Click"
@onready var newspaper: TextureRect = $"../Newspaper"

var loading := false

func _ready() -> void:
	connect("pressed", buttonPressed)
	connect("mouse_entered", mouseEntered)
	connect("mouse_exited", mouseExited)

func mouseEntered():
	if not loading:
		if arrow.position.y != position.y:
			button_click.play()
		arrow.position.y = position.y

func mouseExited():
	pass

func buttonPressed():
	loading = true
	match self.name:
		"New Game":
			if arrow.position.y == new_game.position.y:
				await tween_paper()
				start_game()
			else:
				pass
		"Continue": 
			if arrow.position.y == new_game.position.y:
				print("Continue Selected!")
			else:
				pass
		"Quit Game":
			if arrow.position.y == new_game.position.y:
				print("Quit Game Seleceted!")
				get_tree().quit()
			else:
				pass

func tween_paper():
	var tween = create_tween()
	
	await tween.tween_property(newspaper, "modulate:a", 1.0, 2.0).finished
	tween.kill()
	await get_tree().create_timer(5.0).timeout
	
	var tween2 = create_tween()
	
	await tween2.tween_property(newspaper, "modulate", Color.BLACK, 2.0).finished
	
	return

func start_game():
	get_tree().change_scene_to_file("res://Scenes and Code/Scenes/night_start_screen.tscn")

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		if event.pressed:
#			if event.button_index == MOUSE_BUTTON_LEFT:
#				loading = true
#				match self.name:
#					"New Game":
#						if arrow.position.y == new_game.position.y:
#							await tween_paper()
#							start_game()
#						else:
#							pass
#					"Continue": 
#						if arrow.position.y == new_game.position.y:
#							print("Continue Selected!")
#						else:
#							pass
#					"Quit Game":
#						if arrow.position.y == new_game.position.y:
#							print("Quit Game Seleceted!")
#							get_tree().quit()
#						else:
#							pass
