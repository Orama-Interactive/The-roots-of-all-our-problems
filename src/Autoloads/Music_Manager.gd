extends Node2D

var musicalTween = get_tree().create_tween();
var track1Intro = false;
var track2Intro = false;
var track3Intro = false;


func manageMusic():
	# if (isonlevel1 && !$"Track-1".playing):
	#if (!track1Intro):
	#$"Track-1".volume_db = -100;
	# $"Track-1".play();
	# musicalTween.tween_property($"Track-1", "volume_db", 0, 2.0);
	#=#else:
	# $"Track-1".play();
	#elif (isonlevel2 && !$"Track-2.playing"):
	#if (track2Intro):
	#$"Track-2".volume_db = -100;
	#$"Track-2".play();
	#musicalTween.tween_property($"Track-1", "volume_db", 0, 2.0);
	#else:
	#$"Track-2".play();
	#elif (isonlevel3 && !$"Track-3.playing"):
	# if(!track3Intro):
	#$"Track-3".volume_db = -100;
	#$"Track-3".play();
	#musicalTween.tween_property($"Track-1", "volume_db", 0, 2.0);
	#else:
	# $"Track-3".play();
	pass;



# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#manageMusic();
	pass;



func _on_track_1_finished():
	track1Intro = true;


func _on_track_2_finished():
	track2Intro = true;


func _on_track_3_finished():
	track3Intro = true;
