# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

##
class_name Processor extends Entity

@export var data: ProcessorData

@export var recipe_scene: PackedScene

@export_group("ControlComponents")
@export var title: Label
@export var recipes_container: Container

#region Node Interface

func _ready() -> void:
	super._ready()
	assert(data, "Assign ProcessorData to 'data' in the Inspector.")
	assert(title, "Assign Label to 'title' in the Inspector.")
	title.text = data.id
	_init_recipes()
	pass

#endregion Node Interface

#region Private Methods

func _init_recipes() -> void:
	for r in data.recipes:
		_init_recipe(r)
	pass


func _init_recipe(recipe: RecipeData) -> void:
	var instance := recipe_scene.instantiate() as Recipe
	instance.data = recipe
	instance.name = recipe.id
	recipes_container.add_child(instance)
	pass


#endregion Private Methods