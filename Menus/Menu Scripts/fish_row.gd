extends Control

@onready var label: Label = $VBoxContainer/Label
@onready var icon_rect: TextureRect = $TextureRect
const PLACEHOLDER = preload("uid://bny0fhgrv50w5")


func _ready() -> void:
	label.autowrap_mode = TextServer.AUTOWRAP_WORD

func setup(fish_data: FishData) -> void:
	var count := FishBook.get_count(fish_data.fish_id)
	var lines: Array[String] = []

	if count >= 1:
		lines.append(fish_data.display_name)
	else:
		lines.append("???")
	if count >=1:
		icon_rect.texture = fish_data.icon
	else:
		icon_rect.texture = PLACEHOLDER
	
	if count >= 1: lines.append("")
	if count >= 2: lines.append("Habitat: " + fish_data.habitat)
	if count >= 2: lines.append("")
	if count >= 3: lines.append("Diet: " + fish_data.diet)
	if count >= 3: lines.append("")
	if count >= 4: lines.append("Rarity: " + Constants.FishTier.keys()[fish_data.tier])
	if count >= 4: lines.append("")
	if count >= 5: lines.append("Notes: " + fish_data.description)
	if count >= 5: lines.append("")
	if count >= 6: lines.append("Fun Fact: " + fish_data.fun_fact)

	lines.append("(%d/%d photos)" % [count, Constants.max_photos])

	label.text = "\n".join(lines)
