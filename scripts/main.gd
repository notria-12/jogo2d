extends Node2D
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel


var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _setup_level() -> void:
	var exit = $LevelRoot.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	# Collected apples
	var apples = $LevelRoot.get_node_or_null("Apples")
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
	
	# Connect enemies
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)


#------
# SIGNAL HANDLES
#------
func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Saiu")

func _on_player_died(body): 
	body.die()
	
func increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" % score
