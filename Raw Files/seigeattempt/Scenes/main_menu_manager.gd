extends Node2D
@onready var anchor: Control = $Anchor
@onready var machine: Control = $Machine
@onready var title: RichTextLabel = $Title
var mains = preload("res://Scenes/main_scene.tscn")


func _on_button_pressed() -> void:
	var tweener = get_tree().create_tween()
	tweener.parallel().tween_property(anchor,"position",Vector2(1152,0),.5)
	tweener.parallel().tween_property(title,"position",Vector2(27,-120),.5)
	tweener.tween_property(machine,"position",Vector2(0,-4),.6).set_trans(Tween.TRANS_ELASTIC)
	await tweener.finished
	get_tree().change_scene_to_packed(mains)
