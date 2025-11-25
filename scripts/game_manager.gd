extends Node

# Singleton para gerenciar dados globais do jogo

var map_settings: Dictionary = {
	"map_width": 100,
	"map_height": 100,
	"use_seed": false,
	"seed_value": 0,
	"noise_scale": 0.02,
	"noise_octaves": 4,
	"noise_persistence": 0.5,
	"water_threshold": -0.3,
	"sand_threshold": -0.1,
	"grass_threshold": 0.3,
	"forest_threshold": 0.5,
	"mountain_threshold": 0.7
}

var is_game_paused: bool = false
