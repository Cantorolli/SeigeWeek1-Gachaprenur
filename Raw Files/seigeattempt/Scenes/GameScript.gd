extends Control

var charb = preload("res://Scenes/CharBox.tscn")
@onready var inv: VBoxContainer = $MainSplit/RightMenu/Scroller/Inv
@onready var info: RichTextLabel = $MainSplit/RightMenu/Info
@onready var money_informant: RichTextLabel = $MainSplit/RightMenu/Buttons/MoneyInformant
@onready var char_emmitter: CPUParticles2D = $CharEmmitter
@onready var broke: Popup = $broke
@onready var draw_q: Button = $MainSplit/GashaMenu/MarginContainer/DrawQ
@onready var confirmmenu: Popup = $Confirmmenu
@onready var reset_confirm: Popup = $ResetConfirm
@onready var legendary_label: RichTextLabel = $LegendaryLabel
var defaultpath = "res://CharacterImages/%s"
var pinworth = 0.0



func _process(_delta: float) -> void:
	if !MB.updated:
		_updateworth()
		MB.updated = true

func _ready() -> void:
	for i in MB.inventory:
		for l in CLA.characters:
			var yesdex = CLA.characters[l].values().find(i)
			if yesdex != -1:
				var newscene = charb.instantiate()
				newscene.charname = i[0]
				newscene.rarity = l
				if ResourceLoader.exists(defaultpath % i[1]):
					newscene.img = defaultpath % i[1]
					char_emmitter.texture = ResourceLoader.load(defaultpath % i[1])
				else: 
					newscene.img = defaultpath % "ND.png"
					char_emmitter.texture = ResourceLoader.load(defaultpath % "ND.png")
				inv.add_child(newscene)
				_updateworth()

func _ms_draw():
	var newscene = charb.instantiate()
	var heldindex = CLA._roll()
	newscene.charname = heldindex[0]
	newscene.rarity = heldindex[1]
	if ResourceLoader.exists(defaultpath % heldindex[2]):
		newscene.img = defaultpath % heldindex[2]
		char_emmitter.texture = ResourceLoader.load(defaultpath % heldindex[2])
	else: 
		newscene.img = defaultpath % "ND.png"
		char_emmitter.texture = ResourceLoader.load(defaultpath % "ND.png")
	if newscene.rarity.casecmp_to("Legendary") == 0:
		_legendarypulled()
	inv.add_child(newscene)
	_updateworth()
	MB.updated = false
	var temp = char_emmitter.duplicate()
	temp.emitting = true
	temp.finished.connect(_finished.bind(temp))
	add_child(temp)

func _finished(node):
	node.queue_free()

func _updateworth():
	pinworth = 0
	for i in inv.get_children():
		if i.pinned:
			pinworth += MB.inventory[i.get_parent().get_children().find(i)][2]
	money_informant.text = "Current Funds: $" +str(MB.CurrentMoney) + "\n Bag Capacity: " + str(inv.get_child_count()) + "/100"
	info.text = "Current Inventory Worth: $" + str(MB._getinvworth()) + "\nCurrent Pinned Worth: $"+str(pinworth)


func _on_draw_q_pressed() -> void:
	if MB.CurrentMoney > 0 and inv.get_child_count() < 100:
		MB.CurrentMoney -=1
		_ms_draw()
	elif MB.CurrentMoney <= 0:
		broke.visible = true
		broke.get_child(0).text = "You're out of cash! \nTry selling something."
		draw_q.disabled = true
		await get_tree().create_timer(1).timeout
		broke.visible = false
		draw_q.disabled = false
	else:
		broke.visible = true
		broke.get_child(0).text = "Bag Full! \n Try selling something."
		draw_q.disabled = true
		await get_tree().create_timer(1).timeout
		broke.visible = false
		draw_q.disabled = false

func _legendarypulled():
	legendary_label.visible = true
	await get_tree().create_timer(1).timeout
	legendary_label.visible = false

func _on_button_pressed() -> void:
	MB._filesave()


func _on_commonsell_pressed() -> void:
	for i in inv.get_children():
		if !(i.pinned) and i.rarity.casecmp_to("Common") == 0:
			var currpos = inv.get_children().find(i)
			MB.CurrentMoney += MB.inventory[currpos][2]
			MB.inventory.remove_at(currpos)
			i.free()
	MB.updated = false


func _on_uncommonsell_pressed() -> void:
	for i in inv.get_children():
		if !(i.pinned) and i.rarity.casecmp_to("Uncommon") == 0:
			var currpos = inv.get_children().find(i)
			MB.CurrentMoney += MB.inventory[currpos][2]
			MB.inventory.remove_at(currpos)
			i.free()
	MB.updated = false

func _on_raresell_pressed() -> void:
	for i in inv.get_children():
		if !(i.pinned) and i.rarity.casecmp_to("Rare") == 0:
			var currpos = inv.get_children().find(i)
			MB.CurrentMoney += MB.inventory[currpos][2]
			MB.inventory.remove_at(currpos)
			i.free()
	MB.updated = false


func _on_nah_pressed() -> void:
	confirmmenu.visible = false
	draw_q.disabled = false


func _on_yeah_pressed() -> void:
	for i in inv.get_children():
		if !(i.pinned) and i.rarity.casecmp_to("Epic") == 0:
			var currpos = inv.get_children().find(i)
			MB.CurrentMoney += MB.inventory[currpos][2]
			MB.inventory.remove_at(currpos)
			i.free()
	MB.updated = false
	confirmmenu.visible = false
	draw_q.disabled = false


func _on_epicsell_pressed() -> void:
	confirmmenu.visible = true
	draw_q.disabled = true




func _on_reset_pressed() -> void:
	reset_confirm.visible = true
	draw_q.disabled = true

func _on_yeah_del_pressed() -> void:
	var savepath = "user://save.JSON"
	if FileAccess.file_exists(savepath):
		DirAccess.remove_absolute(savepath)
	reset_confirm.visible = false
	draw_q.disabled = false
	for i in inv.get_children():
		i.queue_free()
	MB.inventory = []
	MB.CurrentMoney = 10
	MB.CurrentPinnedWorth = 0
	MB.updated = false

func _on_nah_del_pressed() -> void:
	reset_confirm.visible = false
	draw_q.disabled = false
