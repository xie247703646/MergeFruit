extends Reference
class_name GameConfig

const fruit_config:Array = [
	{
		"level":0,"radius":26,"fx_scale":0.4,"par_scale":1,
		"texture":preload("res://assets/fruit.sprites/fruit_1.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_1.tres"),preload("res://assets/fx.sprites/fx_1_1.tres")]
	},
	{
		"level":1,"radius":40,"fx_scale":0.5,"par_scale":1.3,
		"texture":preload("res://assets/fruit.sprites/fruit_2.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_2.tres"),preload("res://assets/fx.sprites/fx_2_2.tres")]
	},
	{
		"level":2,"radius":54,"fx_scale":0.6,"par_scale":1.4,
		"texture":preload("res://assets/fruit.sprites/fruit_3.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_3.tres"),preload("res://assets/fx.sprites/fx_3_3.tres")]
	},
	{
		"level":3,"radius":59.5,"fx_scale":0.8,"par_scale":1.6,
		"texture":preload("res://assets/fruit.sprites/fruit_4.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_4.tres"),preload("res://assets/fx.sprites/fx_4_4.tres")]
	},
	{
		"level":4,"radius":76.5,"fx_scale":1,"par_scale":2,
		"texture":preload("res://assets/fruit.sprites/fruit_5.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_5.tres"),preload("res://assets/fx.sprites/fx_5_5.tres")]
	},
	{
		"level":5,"radius":91.5,"fx_scale":1.2,"par_scale":2.2,
		"texture":preload("res://assets/fruit.sprites/fruit_6.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_6.tres"),preload("res://assets/fx.sprites/fx_6_6.tres")]
	},
	{
		"level":6,"radius":96,"fx_scale":1.3,"par_scale":2.5,
		"texture":preload("res://assets/fruit.sprites/fruit_7.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_7.tres"),preload("res://assets/fx.sprites/fx_7_7.tres")]
	},
	{
		"level":7,"radius":129,"fx_scale":1.6,"par_scale":3,
		"texture":preload("res://assets/fruit.sprites/fruit_8.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_8.tres"),preload("res://assets/fx.sprites/fx_8_8.tres")]
	},
	{
		"level":8,"radius":154,"fx_scale":2,"par_scale":3.5,
		"texture":preload("res://assets/fruit.sprites/fruit_9.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_9.tres"),preload("res://assets/fx.sprites/fx_9_9.tres")]
	},
	{
		"level":9,"radius":154,"fx_scale":2.2,"par_scale":4,
		"texture":preload("res://assets/fruit.sprites/fruit_10.tres"),
		"fx_textures":[preload("res://assets/fx.sprites/fx_10.tres"),preload("res://assets/fx.sprites/fx_10_10.tres")]
	},
	{
		"level":10,"radius":204,"fx_scale":1,"par_scale":1,
		"texture":preload("res://assets/fruit.sprites/fruit_11.tres"),
		"fx_textures":[]
	}
]

static func max_level()->int: return fruit_config.size() - 1
