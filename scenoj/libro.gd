extends Control

var menuo : bool = false
var konservi : bool = true

const speco : String = ".gard"
const agord_dosiervojo : String = "user://agordoj.cfg"

onready var tvino : Tween = $VBoxContainer/TopMenu/Tvino
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/TextEdit.text = ""
	sxargi_agordojn()
	
	$Dosierujo.mode_overrides_title = false	
	get_tree().get_root().set_transparent_background(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mus_loko = get_viewport().get_mouse_position()
	if mus_loko.y < 130 and !menuo:
		tvino.interpolate_property($VBoxContainer/TopMenu/Maldekstra, 'modulate', Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0)
		tvino.start()
		menuo = true
	elif mus_loko.y > 130 and menuo:
		tvino.interpolate_property($VBoxContainer/TopMenu/Maldekstra, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0)
		tvino.start()
		menuo = false

func _on_Button_pressed():
	$Dosierujo.mode = FileDialog.MODE_SAVE_FILE
	$Dosierujo.window_title = "Konservi"
	$Dosierujo.show()
	konservi = true

func _on_Sxargi_pressed():
	$Dosierujo.mode = FileDialog.MODE_OPEN_FILE
	$Dosierujo.window_title = "Sxargi"	
	$Dosierujo.show()
	konservi = false

func _on_Button2_pressed():
	get_tree().quit()


func _on_HBoxContainer_mouse_entered():
	print("mouse_entered_menu")


func _on_FileDialogue_dir_selected(dir):
	print(dir)

func _on_FileDialogue_file_selected(path):
	if konservi:
		var dosierujo = path
		if !dosierujo.ends_with("/"):		
			var loko = dosierujo.rfind("/")
			konservi_agordon("agordoj", "dosiero", dosierujo.right(loko + 1))
			konservi_agordon("agordoj", "dosierujo", dosierujo.trim_suffix(dosierujo.right(loko + 1)))
	
		else:
			konservi_agordon("agordoj", "dosierujo", path)
			konservi_agordon("agordoj", "dosiero", "")
			
		if !path.ends_with(speco):
			print("oho")
			path = path + speco
		var eraro = konservi(path)
	
	else:
		var novteksto = sxargi(path)
		$VBoxContainer/TextEdit.text = novteksto


func konservi(dosiervojo : String) -> bool:
	var dosiero = File.new()
	var err = dosiero.open(dosiervojo, 2)
	dosiero.store_string($VBoxContainer/TextEdit.text)
	dosiero.close()

	return err

func sxargi(dosiervojo : String) -> String:
	var dosiero = File.new()
	var err = dosiero.open(dosiervojo, 1)
	var teksto = dosiero.get_as_text()
	dosiero.close()

	return teksto
	
func sxargi_agordojn():
	var agordoj = ConfigFile.new()
	var eraro = agordoj.load(agord_dosiervojo)
	if eraro == OK:
		$Dosierujo.current_dir = agordoj.get_value("agordoj", "dosierujo", "")
		$Dosierujo.current_file = agordoj.get_value("agordoj", "dosiero", "")
	else:
		print("Ankorau ne estis konservita alia dosierujo")
		
func konservi_agordon(sekcio, sloso, variablo):
	var agordoj = ConfigFile.new()
	var eraro = agordoj.load(agord_dosiervojo)
	agordoj.set_value(sekcio, sloso, variablo)
	agordoj.save(agord_dosiervojo)