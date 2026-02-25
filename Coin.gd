extends Area2D

@onready var coin = $CoinSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin.play("coin")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.plusScore(10)
		hide()
		set_deferred("monitoring", false)
