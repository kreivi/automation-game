# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

@tool
extends EditorPlugin

var ingredient_importer: EditorImportPlugin
var recipe_importer: EditorImportPlugin
var processor_importer: EditorImportPlugin

func _enter_tree() -> void:
	ingredient_importer = preload("./import_plugins/IngredientImportPlugin.gd").new()
	add_import_plugin(ingredient_importer)
	recipe_importer = preload("./import_plugins/RecipeImportPlugin.gd").new()
	add_import_plugin(recipe_importer)
	processor_importer = preload("./import_plugins/ProcessorImportPlugin.gd").new()
	add_import_plugin(processor_importer)
	pass


func _exit_tree() -> void:
	remove_import_plugin(ingredient_importer)
	ingredient_importer = null
	remove_import_plugin(recipe_importer)
	recipe_importer = null
	remove_import_plugin(processor_importer)
	processor_importer = null
	pass
