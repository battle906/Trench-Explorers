extends Node

var photo_counts: Dictionary = {}   # fish_id -> int


signal photo_taken(fish_id: String, count: int, money_gained: int)
signal fish_completed(fish_id: String)

func get_count(fish_id: String) -> int:
	return photo_counts.get(fish_id, 0)

func is_complete(fish_id: String) -> bool:
	return get_count(fish_id) >= Constants.max_photos

func add_photo(fish: Node) -> bool:
	var fish_id: String = fish.data.fish_id
	var count := get_count(fish_id)
	if count >= Constants.max_photos:
		return false

	count += 1
	photo_counts[fish_id] = count

	var reward: int = Constants.TIER_MONEY[fish.data.tier]
	Constants.money += reward

	photo_taken.emit(fish_id, count, reward)
	if count >= Constants.max_photos:
		fish_completed.emit(fish_id)
	SaveManager.mark_dirty()

	return true

func save_data() -> Dictionary:
	return {"photo_counts": photo_counts, "money": Constants.money}

func load_data(data: Dictionary) -> void:
	photo_counts = data.get("photo_counts", {})
	Constants.money = data.get("money", 0)


func debug_add_photo_by_id(fish_id: String, tier: Constants.FishTier) -> bool:
	var count := get_count(fish_id)
	if count >= Constants.max_photos:
		return false

	count += 1
	photo_counts[fish_id] = count

	var reward: int = Constants.TIER_MONEY[tier]
	Constants.money += reward

	photo_taken.emit(fish_id, count, reward)
	if count >= Constants.max_photos:
		fish_completed.emit(fish_id)


	return true
