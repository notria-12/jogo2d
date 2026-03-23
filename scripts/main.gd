extends Node2D
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var game_over_menu: Panel = $HUD/GameOverMenu
@onready var game_over_score_label: Label = $HUD/GameOverMenu/VBoxContainer/GameOverScoreLabel
@onready var game_over_title_label: Label = $HUD/GameOverMenu/VBoxContainer/TitleLabel


var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()
	$HUD/GameOverMenu/VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)


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
		body.alive = false
		_show_end_menu("YOU WIN!")

func _on_player_died(body): 
	body.die()
	_show_end_menu("GAME OVER")
	
func _show_end_menu(title: String) -> void:
	game_over_title_label.text = title
	game_over_score_label.text = "SCORE: %s" % score
	game_over_menu.visible = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" % score
