extends Node2D

var obstacle_tscn := preload("res://src/obstacle.tscn")
var tree_tscn := preload("res://src/tree.tscn")
var checkpoints: Array[Checkpoint] = [
	Checkpoint.new(0, "", "The seed flew east, through a forest. (press [space] to jump)", "(forest ambience)"),
	Checkpoint.new(700, "forest_fade_1", "Navigating its way through the forest, the seed had to avoid the tree tops"),
	Checkpoint.new(1200, "forest_fade_2", "“This forest is way too dense” the seed thought. I won’t be able to root properly here, with so little sun."),
	Checkpoint.new(1700, "town_fade_in_1", "But then, the seed lost its train of thought to a cracking sound.", "(sound of a tree being chopped and sound of trees falling)"),
	Checkpoint.new(2000, "", "Why are the trees falling out of nowhere? Maybe that’s my chance to root!"),
	Checkpoint.new(3000, "", "But as the seed navigated further into the forest it realised that this place is far from safe.", "(sounds of rocks and arrows+new obstacles)"),
	Checkpoint.new(4000, "", "The trees were falling one after the other. What could have caused such a catastrophe?"),
	Checkpoint.new(5000, "", "I have to travel further, the seed thought and it gathered all of its strength and courage to go even further."),
	Checkpoint.new(6000, "", "But things were getting even more weird the further it went. The forest lost its colours and the sound became louder and louder", "(sounds of a busy city)"),
	Checkpoint.new(7000, "", "“There’s barely any soil here, how will I find a place to root?” The seed thought as it traveled even further in that gray looking forest."),
	Checkpoint.new(8000, "", "And suddenly, a sound unlike any other.", "(bomb falling, exploding)"),
	Checkpoint.new(9000, "", "And everything was calm again.", "(sound of fire)"),
	Checkpoint.new(10000, "", "The forest was long gone."),
	Checkpoint.new(11000, "", "But the poor seed had little strength, for it had used all of its energy looking for a better place to root."),
	Checkpoint.new(12000, "", "Maybe this place were never meant to be found. Because of a greedy species with zero consideration for nature or even its own kind was a bad encounter in the seed’s adventure that it shouldn’t have to have."),
	Checkpoint.new(13000, "", "A parasite, here only to destroy. Periods of conflict followed, leaving fire and blood at their trails. Hope was naught but a faint light, yet wars were in humanity’s nature, never to be stopped."),
]
var current_checkpoint := 0
@onready var player: Player = $Player
@onready var tree_parent: Node2D = $TreeParent
@onready var tree_timer: Timer = $TreeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var subtitles: Label = $CanvasLayer/Control/Subtitles


class Checkpoint:
	var pos := 0.0
	var animation := ""
	var text := ""
	var ambient_text := ""

	func _init(_pos: float, _animation := "", _text := "", _ambient_text := "") -> void:
		pos = _pos
		animation = _animation
		text = _text
		ambient_text = _ambient_text


func _ready() -> void:
	if GameManager.loaded:
		current_checkpoint = GameManager.load()
		player.position.x = checkpoints[current_checkpoint].pos + 1
	change_checkpoint()


func _process(_delta: float) -> void:
	var pos := round(player.position.x)
	$CanvasLayer/Control/Label.text = str(pos)
	if current_checkpoint >= checkpoints.size() -1:
		return
	if pos >= checkpoints[current_checkpoint + 1].pos:
		current_checkpoint += 1
		change_checkpoint()


func change_checkpoint() -> void:
	GameManager.save(current_checkpoint)
	if not checkpoints[current_checkpoint].animation.is_empty():
		animation_player.play(checkpoints[current_checkpoint].animation)
	match current_checkpoint:
		0:
			tree_timer.start()
	subtitles.text = checkpoints[current_checkpoint].text
	if GameManager.show_ambient_subtitles:
		subtitles.text += "\n" + checkpoints[current_checkpoint].ambient_text


func _on_obstacle_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_tscn.instantiate()
	var pos := Vector2(player.position.x + 1940, 0)
	obstacle.position = pos
	add_child(obstacle)


func _on_tree_timer_timeout() -> void:
	var pos := Vector2(player.position.x + 2040, 1080)
	var tree := tree_tscn.instantiate()
	tree.position = pos
	tree_parent.add_child(tree)
	if player.position.x > checkpoints[3].pos:
		tree_timer.stop()
	elif player.position.x > checkpoints[2].pos:
		tree_timer.wait_time = randf_range(4, 7)
	elif player.position.x > checkpoints[1].pos:
		tree_timer.wait_time = randf_range(1, 4)
	else:
		tree_timer.wait_time = randf_range(0.2, 2)
