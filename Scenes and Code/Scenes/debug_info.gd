extends CanvasLayer

@onready var freddy_location: Label = $"Freddy Location"
@onready var chica_location: Label = $"Chica Location"
@onready var bonnie_location: Label = $"Bonnie Location"
@onready var foxy_location: Label = $"Foxy Location"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	freddy_location.text = "Freddy Location: " + Global.fpos
	chica_location.text = "Chica Location: " + Global.cpos
	bonnie_location.text = "Bonnie Location: " + Global.bpos
	foxy_location.text = "Foxy Location: " + Global.foxpos + "\nFoxy Stage: " + str(Global.foxy_stage) + "\nFoxy Stalled for: " + str($"../Animatronic AI/Foxy/Stall Timer".time_left)
