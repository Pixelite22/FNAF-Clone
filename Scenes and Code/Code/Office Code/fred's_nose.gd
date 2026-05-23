extends Button

@onready var boop_noise: AudioStreamPlayer2D = $"Boop Noise"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	boop_noise.play() #When nose pressed go boop
