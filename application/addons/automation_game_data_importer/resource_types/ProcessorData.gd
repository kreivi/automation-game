# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## Processors handle recipes.
class_name ProcessorData extends EntityData

## Recipes this processor can handle.
@export var recipes: Array[RecipeData] = []

@export var input_storages: Array[QuantitativeData] = []
@export var output_storages: Array[QuantitativeData] = []

func get_recipe_by_id(id: String) -> RecipeData:
	for recipe in recipes:
		if recipe.id == id:
			return recipe
		pass
	return null


func find_storage_by_id(data: Array[QuantitativeData], id: String) -> QuantitativeData:
	for storage in data:
		if storage.ingredient and storage.ingredient.id == id:
			return storage
		pass
	return null


func get_input_storage_by_id(id: String) -> QuantitativeData:
	return find_storage_by_id(input_storages, id)


func get_output_storage_by_id(id: String) -> QuantitativeData:
	return find_storage_by_id(output_storages, id)