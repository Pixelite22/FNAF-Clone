extends Label
var can_skip := true

var menu = preload("res://Scenes and Code/Scenes/title.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween_message("in")

func tween_message(fade: String):
	var tween = create_tween()
	
	if fade == "in":
		await tween.tween_property(self, "modulate:a", 1.0, 1.0).finished
		tween.kill()
		await get_tree().create_timer(1.0).timeout
		tween_message("out")
	elif fade == "out":
		await tween.tween_property(self, "modulate:a", 0.0, 1.0).finished
		tween.kill()
		switch_to_main_menu()

func switch_to_main_menu():
		get_tree().change_scene_to_packed(menu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_warning") and can_skip:
		can_skip == false
		tween_message("out")
