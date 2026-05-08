extends Control

@onready var text: Label = $Text
@onready var blip_flash: AnimatedSprite2D = $"Blip Flash"
@onready var blip_audio: AudioStreamPlayer2D = $"Blip Flash/Blip Audio"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blip_flash.connect("animation_finished", fade_out)
	blip_audio.play()
	

func fade_out():
	await get_tree().create_timer(2.0).timeout
	
	var tween = create_tween()
	
	tween.tween_property(text, "modulate:a", 0.0, 1.0)
	
	var office = load("res://Scenes and Code/Scenes/Office.tscn")
	get_tree().change_scene_to_packed(office)
