extends Node

var raritypool = {"Legendary":0.6,"Epic":6.4,"Rare":20.0,"Uncommon":30.0,"Common":50.0}
var characters = {}
var inventorylist = []

func _round2place(number:float,places:int):
	number = number * pow(10,places)
	number = roundf(number)
	number = number/pow(10,places)
	return number

func _ready() -> void:
	_gachapool()

func _roll():
	var rarity = _gacharoll()
	var currpool = characters[rarity] 
	var currpool_indx = randi_range(0,currpool.size()-1)
	MB.inventory.append(currpool.values()[currpool_indx])
	return [str(currpool.values()[currpool_indx][0]) , rarity, currpool.values()[currpool_indx][1]]

func _gacharoll():
	var currentpullvalue = randf_range(0,100.0)
	currentpullvalue = _round2place(currentpullvalue,1)
	for n in raritypool.size():
		if currentpullvalue >= raritypool.values()[n]:
			currentpullvalue -= raritypool.values()[n]
		else:
			return str(raritypool.keys()[n])

# Copy-Pasted code from another personal project, adjusted a tad for this project
func _gachapool():
	var dir = DirAccess.open("res://JsonFiles/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if ".json" in file_name:
				var currentfile = "res://JsonFiles/"+file_name
				var file = FileAccess.open(currentfile,FileAccess.READ)
				var content = file.get_as_text()
				characters = JSON.parse_string(str(content))
			file_name = dir.get_next()
		dir.list_dir_end()
