extends AnimatedSprite2D

@onready var twitch: Timer = $Twitch
@onready var rest: Timer = $Rest
@onready var nose_boop: Button = $"Nose Boop Detect"
@onready var nose_boop_sound: AudioStreamPlayer2D = $"Nose Boop Sound"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restStart() #strrts the timer that keeps track of when he should be at rest

#Called when the rest timer times out
func restTimeout():
	frame = randi_range(1, 3) #Set freddy to one of the frames in the pool
	twitchStart() #Call twitch start

#Called when the twitch timer timesout, meaning he should be back at rest
func twitchTimeout():
	frame = 0 #Set the frame to normal feddy
	restStart() #Call for the rest timer to start

func restStart():
	rest.wait_time = randf_range(0.3, 4.0) #Set the time he waits in rest randomly between 3 tenths of a second to 4 seconds
	rest.start() #Start the timer

func twitchStart():
	twitch.wait_time = randf_range(0.02, 0.07) #Set the time twitching from 2 tenths of a second to 7 tenths
	twitch.start() #Start the timer


func _on_nose_boop_pressed() -> void:
	nose_boop_sound.play()
	
