extends UIBase
class_name UICelebrate

onready var shine:TextureRect = $Control/Shine
onready var particle:CPUParticles2D = $CPUParticles2D
onready var anim_player:AnimationPlayer = $AnimationPlayer
onready var timer:Timer = $Timer

func _ready() -> void:
	play()

func _physics_process(delta: float) -> void:
	shine.rect_rotation += delta * 100

func play()->void:
	particle.emitting = true
	anim_player.play("show")
	timer.start()

func _on_Timer_timeout() -> void:
	close()
