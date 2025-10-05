extends PanelContainer

@onready var reference_rect: ReferenceRect = $ReferenceRect
@export var charname: String = "Normal Dude"
@export var rarity: String = "Common"
@export_file("*.png") var img = "res://CharacterImages/ND.png"
var pinned = false
var amIhoveredQ = false
@onready var littleguy: TextureRect = $HBoxContainer/littleguy
@onready var pin_stat: TextureRect = $HBoxContainer/PinStat
@onready var rich_text_label: RichTextLabel = $HBoxContainer/RichTextLabel

func _ready() -> void:
	rich_text_label.text = charname + " - " + rarity
	littleguy.texture = load(img)

func _process(_delta: float) -> void:
	if amIhoveredQ:
		if Input.is_action_just_pressed("Left-Click") and !pinned:
				_sell()
		elif Input.is_action_just_pressed("Right-Click"):
			pinned = !pinned
			MB.updated = false
			if pinned: pin_stat.texture = load("res://GeneralAssets/Locked.png")
			else: pin_stat.texture = null

func _sell():
	MB.CurrentMoney += MB.inventory[get_parent().get_children().find(self)][2]
	MB.inventory.remove_at((get_parent().get_children().find(self)))
	MB.updated = false
	queue_free()

func _on_reference_rect_mouse_entered() -> void:
	reference_rect.border_color = Color(1,1,1,1)
	amIhoveredQ = true

func _on_reference_rect_mouse_exited() -> void:
	reference_rect.border_color = Color(0,0,0,0)
	amIhoveredQ = false
