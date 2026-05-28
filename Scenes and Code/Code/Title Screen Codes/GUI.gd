extends CanvasLayer

@onready var continuebutton: Button = $Continue
@onready var sixth_night: Button = $"6th Night"
@onready var quit_game: Button = $"Quit Game"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.night <= 1:
		quit_game.position = continuebutton.position
		continuebutton.hide()
		sixth_night.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
