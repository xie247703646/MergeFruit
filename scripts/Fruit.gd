extends RigidBody2D
class_name Fruit

onready var sp:Sprite = $Sprite
onready var collision:CollisionShape2D = $CollisionShape2D
onready var audio_on_floor:AudioStreamPlayer = $AudioOnFloor

var is_new:bool = true
var level:int = 0 setget _set_level,_get_level
var radius:float = 0
var danger_cnt:int = 0

func _set_level(v)->void:
	level = v
	var config = GameConfig.fruit_config[level]
	radius = config.radius
	collision.shape.radius = radius
	sp.texture = config.texture
	mass = config.par_scale

func _get_level()->int:
	return level

var was_collided:bool = false
var is_in_merge:bool = false

func _on_Fruit_body_entered(body: Node) -> void:
	if not is_in_merge and body.is_in_group("fruit"):
		var fruit:Fruit = body
		if self.level == fruit.level and self.level < GameConfig.max_level():
			self.is_in_merge = true
			fruit.is_in_merge = true
			SignalMgr.emit_signal("fruit_merged",self,fruit)

	if body.name == "Floor" and not was_collided:
		was_collided = true
		audio_on_floor.play()

	if is_new and (body.is_in_group("fruit") or body.name == "Floor"):
		is_new = false
		SignalMgr.emit_signal("create_fruit")
