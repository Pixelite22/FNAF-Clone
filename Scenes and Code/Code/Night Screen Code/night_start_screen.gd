extends Control

@onready var text: Label = $Text
@onready var blip_flash: AnimatedSprite2D = $"Blip Flash"
@onready var blip_audio: AudioStreamPlayer2D = $"Blip Flash/Blip Audio"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect the animation finished node to the fade out function from the blip flash node
	blip_flash.connect("animation_finished", fade_out)
	blip_audio.play() #and play the audio on the blip audio node
	

func fade_out():
	#wait 2 seconds
	await get_tree().create_timer(2.0).timeout
	
	var tween = create_tween()
	
	#tween the alpha down to make the text invisible
	tween.tween_property(text, "modulate:a", 0.0, 1.0)
	
	#load the office scene and change to it
	var office = load("res://Scenes and Code/Scenes/Office.tscn")
	get_tree().change_scene_to_packed(office)
