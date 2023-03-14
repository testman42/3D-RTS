extends Node

# TODO: Should this be just a framework that gets populated by some other script?
# TODO: how do we ENUM this thing, so that it doesn't rely on string comparisons

# Constructions:
# 1 = Reactor
# 2 = 
# 3 = 
# 4 = 
# 5 = 
# 6 = 
# 7 = 
# 8 = 
# 9 = 
# 10 = 

# Units:
# 1 = Collector
# 2 = 

var construction_reqirements = {}
var object_reqirements = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	object_reqirements["buildings"] = {}
	object_reqirements["units"] = {}
#	object_reqirements["vehicles"] = {}
	
	
	object_reqirements["buildings"]["rr"] = ["cc"]
	object_reqirements["buildings"]["tt"] = ["cc", "rr"]
	object_reqirements["buildings"]["gg"] = ["cc", "rr"]
	object_reqirements["buildings"]["oo"] = ["cc", "gg", "tt"]
	object_reqirements["buildings"]["pp"] = ["cc", "oo"]
	
	object_reqirements["units"]["collector"] = ["gg"]
	object_reqirements["units"]["testcar"] = ["gg"]
	object_reqirements["units"]["testtank"] = ["gg"]
	
	construction_reqirements["rr"] = ["cc"]
	construction_reqirements["tt"] = ["cc", "rr"]
	construction_reqirements["gg"] = ["cc", "rr"]
	construction_reqirements["oo"] = ["cc", "gg", "tt"]
	construction_reqirements["pp"] = ["cc", "oo"]

# assume duplicates removed
# TODO: don't assume duplicates removed
func get_options(list):
#	var construction_options = []
	var construction_options = {}
	construction_options["buildings"] = []
	construction_options["units"] = []
#	construction_options["vehicles"] = []
#	for key in construction_reqirements:
	for category in object_reqirements:
		for key in object_reqirements[category]:
			var requirement_count = object_reqirements[category][key].size()
			var requirement_present = 0
			for item in list:
				for requirement in object_reqirements[category][key]:
					if item == requirement:
						requirement_present += 1
			if requirement_present == requirement_count:
				construction_options[category].append(key)
	return construction_options
