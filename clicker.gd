class_name Clicker extends Control


var wobble_time : float = 0
var wobble_speed : float = 5
var wobble_amp : float = 0.1

var rec_squeaks : int = 0

var BBBprice : int = 20
var Bapperammount : int = 0

var squish_tween : Tween 

#Start Fuctions
func _ready() -> void:
	_update_label()
	_update_bbbprice()

#Simple on pressed
func _on_button_pressed() -> void:
	_squeak()

#Visual squeak with points
func _squeak() -> void:
	global.squeaks += global.clickhit
	%CPUParticles2D.restart()
	%CPUParticles2D.emitting = true
	_update_label()
	_play_squeak()
	_squish_button()

#Update Squeaks Label
func _update_label() -> void:
	%Label.text = "Squeaks : %s" %global.squeaks

#Updates Buy Bapper Button
func _update_bbbprice() -> void:
	%BBB.text = "Buy Bapper : %s" %BBBprice

#Plays the squeak sound
func _play_squeak() -> void:
	%SqueakSound.pitch_scale = randf_range(0.8,1.2)
	%SqueakSound.playing = true


func _process(delta: float) -> void:
	
	#Button Wabble
	wobble_time += delta * wobble_speed 
	%Button.rotation = sin(wobble_time) * wobble_amp
	
	#Button return to normal without a tween
	if %Button.scale <= Vector2(0.5,0.5) :
		%Button.scale += Vector2(delta,delta)
	
	#Disable BBB and BSB buttons when not available
	if BBBprice > global.squeaks :
		%BBB.disabled = true
	else :
		%BBB.disabled = false
	
	#Update Stats label, note to self when upgrade system is made to move this there, the less calls the better
	%StatBapper.text = "Bappers : %s" %Bapperammount
	%StatBapSpd.text = "Bapper Speed : %s sec" %global.bapperspeed
	%StatBapSqk.text = "Bapper Attack : %s" %global.bapperhit
	%StatClickSqk.text = "Click Attack : %s" %global.clickhit
	%StatCritCha.text = "Crit Chance : %s %%" %global.critchance
	%StatUpgrd.text = "Upgrade Luck : %s" %global.upgradeeffect
	_update_label()

#Squish button on click without tween
func _squish_button() -> void:
	if %Button.scale >= Vector2(0.05,0.05) :
		%Button.scale -= Vector2(%Button.scale.x/8,%Button.scale.y/8)

#Calculates Squeaks per seccond
func _on_sps_timer_timeout() -> void:
	$SPS.text = "Squeaks Per Seccond : %s" %(global.squeaks-rec_squeaks)
	rec_squeaks = global.squeaks

#purchace BBB
func _on_bbb_pressed() -> void:
	if global.squeaks >= BBBprice :
		global.squeaks -= BBBprice
		BBBprice += floor(BBBprice/3)
		add_child((load("res://CyClicker/bapper.tscn") as PackedScene).instantiate())
		Bapperammount += 1
		_update_label()
		_update_bbbprice()


#Vol slider function
func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, 10*(log(value)/log(10)))
