extends Node

var CurrentMoney: int
var CurrentInventoryWorth: int
var CurrentPinnedWorth: int
var inventory:Array = []
var rarities:Array = ["Common","Uncommon","Rare","Epic","Legendary"]
var updated: bool

func _getinvworth():
	CurrentInventoryWorth = 0
	for i in inventory:
		CurrentInventoryWorth += i[2]
	return CurrentInventoryWorth

func  _ready() -> void:
	if !FileAccess.file_exists("user://Save.JSON"):
		CurrentMoney = 10
	else:
		_fileload()

func _filesave():
	var saving = FileAccess.open("user://Save.JSON",FileAccess.WRITE)
	var saveddictionary = {
		"CurrMon":CurrentMoney,
		"CurrInvWorth":CurrentInventoryWorth,
		"CurrPinWorth":CurrentPinnedWorth,
		"inventory":inventory}
	saving.store_line(JSON.stringify(saveddictionary))

func _fileload():
	var loading = FileAccess.open("user://Save.JSON",FileAccess.READ)
	var content = loading.get_as_text()
	content = JSON.parse_string(content)
	CurrentInventoryWorth = content.values()[0]
	CurrentMoney = content.values()[1]
	CurrentPinnedWorth = content.values()[2]
	inventory = content.values()[3]
