extends Node2D


@export var PIXELS_PER_METER = 50
@export var speed2 = 100
@onready var Player := preload("uid://dt5wefvttquat")
@export var max_depth := 100
var upgrade_level: int = 0 
const DEFAULT_MAX_DEPTH := 100.0  
const DEFAULT_SPEED2 := 100.0  
@onready var DefultPlayer := preload("uid://dt5wefvttquat")

#fish tiers 
enum FishTier { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

const TIER_MONEY := {
	FishTier.COMMON: 20,
	FishTier.UNCOMMON: 25,
	FishTier.RARE: 60,
	FishTier.EPIC: 120,
	FishTier.LEGENDARY: 320,
}

const max_photos := 6

var money: int = 0
