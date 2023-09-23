extends Node3D

#ONREADY VARIABLES:

#PUBLIC VARIABLES:
@export var m_rotSpd = 3
@export var m_characters:Array[PackedScene]
@export var m_characterName : Label
@export var m_artistName : Label
@export var m_characterDescription : Label
@export var m_madeby : Label
@export var m_background : WorldEnvironment
@export var m_spt01 : TextureRect
@export var m_spt02 : TextureRect
@export var m_spt01text : Label
@export var m_spt01title : Label
@export var m_spt02text : Label
@export var m_spt02title : Label
@export var m_cylinder : MeshInstance3D

#PRIVATE VARIABLES:
var current = 0

#SCRIPT:
func _ready():
	add_child(m_characters[current].instantiate())
	_updateCharModel(current)
	_updateInfos()

func _process(delta):
	rotate(Vector3(0, -m_rotSpd, 0).normalized(), delta)

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
	m_characterName.text = str(get_child(1).get_meta('characterName'))
	m_artistName.text = str(get_child(1).get_meta('artistName'))
	m_characterDescription.text = str(get_child(1).get_meta('characterDescription'))
	
	#set the colours.
	m_characterName.label_settings.font_color = get_child(1).get_meta('headersColor')
	m_artistName.label_settings.font_color = get_child(1).get_meta('headersColor')
	m_background.environment.set_bg_color(get_child(1).get_meta('backgroundColor'))
	m_cylinder.mesh.surface_get_material(0).albedo_color = get_child(1).get_meta('backgroundColor')
	m_spt01title.label_settings.font_color = get_child(1).get_meta('headersColor')
	
	#set the sprites images.
	m_spt01.set_texture(load(str(get_child(1).get_meta('image01'))))
	m_spt02.set_texture(load(str(get_child(1).get_meta('image02'))))
	
	#set the sprites text infos.
	m_spt01title.text = str(get_child(1).get_meta('img01title'))
	m_spt01text.text = str(get_child(1).get_meta('img01text'))
	m_spt02title.text = str(get_child(1).get_meta('img02title'))
	m_spt02text.text = str(get_child(1).get_meta('img02text'))
	
	print("updated!")


func _on_button_arrow_right_pressed():
	_updateCharModel(1)

func _on_button_arrow_left_pressed():
	_updateCharModel(-1)
