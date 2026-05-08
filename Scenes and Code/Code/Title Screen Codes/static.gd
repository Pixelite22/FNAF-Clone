extends AnimatedSprite2D

@onready var big_static: AnimatedSprite2D = $"Big Static"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#play() #Play the main static loop on this node, autoplay made this useless
	play_random_big_static() #And call the function that plays the other types of static

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_random_big_static():
	big_static.play(str(randi_range(1, 6))) #Play a random static effect, labeled 1 - 6
	
	await big_static.animation_finished #Wait for the static to finish
	
	await get_tree().create_timer(randf_range(0, 5)).timeout #Wait 0 to 5 seconds for the next static effect
	
	play_random_big_static() #Recursively call this function to have the static play again
