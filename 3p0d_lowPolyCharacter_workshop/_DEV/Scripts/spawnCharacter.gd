extends Node3D

#ONREADY VARIABLES:
@onready var _characterName : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/Label_CharacterName"
@onready var _artistName : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/HBox_MadeByArtistName/Label_ArtistName"
@onready var _characterDescription : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/Label_Description"
@onready var _madeby : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/HBox_MadeByArtistName/Label_MadeBy"
@onready var _spt01text : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite1/VBox_sprite1/Label_sprite1text"
@onready var _spt01title : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite1/VBox_sprite1/Label_sprite1title"
@onready var _spt02text : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite2/VBox_sprite2/Label_sprite2text"
@onready var _spt02title : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite2/VBox_sprite2/Label_sprite2title"
@onready var _spt01 : TextureRect = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite1/TextureRect_sprite1"
@onready var _spt02 : TextureRect = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite2/TextureRect_sprite2"
@onready var _btnArrowL : Button = $"../_UI/Control_Arrows/Button_arrowLeft"
@onready var _btnArrowR : Button = $"../_UI/Control_Arrows/Button_arrowRight"
@onready var _btnMenu : Button = $"../_UI/Control_Menus/MarginContainer_Menu/Button_Menu"
@onready var _btnQuit : Button = $"../_UI/Control_Menus/MarginContainer_Quit/Button_Quit"
@onready var _stgpanel : Panel = $"../_UI/Control_Settings/Panel_Settings"
@onready var _ctrlmenus : Control = $"../_UI/Control_Menus"
@onready var _sldSat : HSlider = $"../_UI/Control_Settings/Panel_Settings/VBoxContainer/Panel_Saturation/MgCont_Saturation/HBox_Saturation/HSlider_Saturation"
@onready var _sldBrght : HSlider = $"../_UI/Control_Settings/Panel_Settings/VBoxContainer/Panel_Brightness/MgCont_Brightness/HBox_Brightness/HSlider_Brightness"
@onready var _sldCont : HSlider = $"../_UI/Control_Settings/Panel_Settings/VBoxContainer/Panel_Contrast/MgCont_Contrast/HBox_Contrast/HSlider_Contrast"
@onready var _sldSpd : HSlider = $"../_UI/Control_Settings/Panel_Settings/VBoxContainer/Panel_RotationSpd/MgCont_RotationSpd/HBox_RotationSpd/HSlider_RotationSpd"
@onready var _iconsBy : Label = $"../_UI/Control_Settings/Panel_Settings/VBoxContainer/Panel_CurrentCredit/MgCont_Contrast/HBox_Contrast/Label_Credits"
@onready var _toggle : CheckBox = $"../_UI/Control_Settings/Panel_Settings/VBoxContainer/HBoxContainer/Panel_HideMenus/MgCont_HideMenus/HBox_HideMenus/Panel_HideMenus/CheckBox_HideMenus"

#PUBLIC VARIABLES:
@export var m_rotSpd = 0.5
@export var m_characters:Array[PackedScene]
@export var m_cylinder : MeshInstance3D
@export var m_background : WorldEnvironment
@export var m_settings : Control

#PRIVATE VARIABLES:
var current : float = 0

#---------------------------------GAMEPLAY SCRIPT---------------------------------:
func _ready():
	m_settings.set_visible(false)
	add_child(m_characters[current].instantiate())
	_updateCharModel(current)
	_updateInfos()
	_setDefaultEnv()

func _process(delta):
	rotate(Vector3(0, -1, 0).normalized(), delta * m_rotSpd)

func _updateCharModel(val):
	#---sets the min and max of the loop, and increment of the loop at each click.
	#---the values of the min and max have -1 and +1 to allow the loop to work.
	current += val
	current = min(current, m_characters.size())
	current = max(-1, current)

	#---infinite loop of choice to return to 0 or m_characters.size()-1 when you reach -1 or m_characters.size().
	if (current < 0):
		current = m_characters.size()-1
	if (current > m_characters.size()-1):
		current = 0

	#---remove all the previous models that is currently in the hierarchy of the object.
	for i in get_children():
		i.queue_free()
	
	#---adds the model of the current index of the m_characters.
	add_child(m_characters[current].instantiate())
	
	_updateInfos()

func _updateInfos():
	#set the character text infos.
	_characterName.text = str(get_child(1).get_meta('characterName'))
	_artistName.text = str(get_child(1).get_meta('artistName'))
	_characterDescription.text = str(get_child(1).get_meta('characterDescription'))
	
	#set the colours.
	_characterName.label_settings.font_color = get_child(1).get_meta('headersColor')
	_artistName.label_settings.font_color = get_child(1).get_meta('headersColor')
	_spt01title.label_settings.font_color = get_child(1).get_meta('headersColor')
	
	_btnArrowR.set("theme_override_colors/icon_hover_color", get_child(1).get_meta('headersColor'))
	_btnArrowL.set("theme_override_colors/icon_hover_color", get_child(1).get_meta('headersColor'))
	
	m_background.environment.set_bg_color(get_child(1).get_meta('backgroundColor'))
	m_cylinder.mesh.surface_get_material(0).albedo_color = get_child(1).get_meta('backgroundColor')
	
	_stgpanel.set("theme_override_styles/panel/bg_color", get_child(1).get_meta('headersColor'))
	
	#set the sprites images.
	_spt01.set_texture(load(str(get_child(1).get_meta('image01'))))
	_spt02.set_texture(load(str(get_child(1).get_meta('image02'))))
	
	#set the sprites text infos.
	_spt01title.text = str(get_child(1).get_meta('img01title'))
	_spt01text.text = str(get_child(1).get_meta('img01text'))
	_spt02title.text = str(get_child(1).get_meta('img02title'))
	_spt02text.text = str(get_child(1).get_meta('img02text'))
	
	_iconsBy.text = str("Image 01 " + get_child(1).get_meta('source01') + " / Image 02 " + get_child(1).get_meta('source02') + " - CC BY 3.0 - www.game-icons.net")
	
	print("updated!")
	
	
func _setDefaultEnv():
	m_background.environment.set_adjustment_contrast(1)
	_sldCont.value = 1
	m_background.environment.set_adjustment_brightness(1.2)
	_sldBrght.value = 1.2
	m_background.environment.set_adjustment_saturation(1.2)
	_sldSat.value = 1.2

#---------------------------------GAMEPLAY SIGNALS---------------------------------:

func _on_timer_no_activity_timeout():
	_updateCharModel(1)

func _on_button_arrow_right_pressed():
	_updateCharModel(1)

func _on_button_arrow_left_pressed():
	_updateCharModel(-1)

func _on_button_quit_pressed():
	get_tree().quit()


#---------------------------------SETTINGS SIGNALS---------------------------------:
func _input(ev):
	if Input.is_action_pressed("right"):
		_updateCharModel(1)
	
	if Input.is_action_pressed("left"):
		_updateCharModel(-1)
	
	if Input.is_action_just_pressed("esc"):
		if _ctrlmenus.visible == false and m_settings.visible == false:
			_ctrlmenus.set_visible(true)
			_toggle.set_pressed(true)
		elif _ctrlmenus.visible == true and m_settings.visible == false:
			m_settings.set_visible(true)
		elif m_settings.visible == true:
			m_settings.set_visible(false)

func _on_button_menu_pressed():
	m_settings.set_visible(true)

func _on_button_quit_settings_pressed():
	m_settings.set_visible(false)
	
func _on_check_box_fullscreen_toggle_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_check_box_hide_menus_toggled(button_pressed):
	_ctrlmenus.set_visible(false)
	if button_pressed:
		_ctrlmenus.set_visible(true)

func _on_h_slider_rotation_spd_value_changed(value):
	m_rotSpd = value

func _on_h_slider_saturation_value_changed(value):
	m_background.environment.set_adjustment_saturation(value)

func _on_h_slider_brightness_value_changed(value):
	m_background.environment.set_adjustment_brightness(value)
	
func _on_h_slider_contrast_value_changed(value):
	m_background.environment.set_adjustment_contrast(value)

func _on_button_reset_default_pressed():
	_setDefaultEnv()
	_sldSpd.value = 0.5
	_ctrlmenus.set_visible(true)
