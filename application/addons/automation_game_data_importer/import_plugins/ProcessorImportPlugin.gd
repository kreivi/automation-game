# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## Import plugin for processors.
@tool
extends EditorImportPlugin

enum Presets {
	DEFAULT,
}

#region EditorImportPlugin Implementation

func _get_importer_name() -> String:
	return "automationgame.data.importer.processors"


func _get_visible_name() -> String:
	return "Automation Game - Processors"


func _get_recognized_extensions() -> PackedStringArray:
	return ["json"]


func _get_save_extension() -> String:
	return "md5"


func _get_preset_count() -> int:
	return Presets.size()


func _get_preset_name(preset_index: int) -> String:
	match preset_index:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"


func _get_import_options(path: String, preset: int) -> Array[Dictionary]:
	match preset:
		Presets.DEFAULT:
			return [
				{
					"name": "WriteDirectory",
					"default_value": "res://data/entities/processors",
					"property_hint": PROPERTY_HINT_DIR,
					"hint_string": "The directory where the imported processors will be saved.",
				},
				{
					"name": "IngredientsDirectory",
					"default_value": "res://data/entities/ingredients",
					"property_hint": PROPERTY_HINT_DIR,
					"hint_string": "The directory where the imported ingredients are located.",
				},
				{
					"name": "RecipesDirectory",
					"default_value": "res://data/entities/recipes",
					"property_hint": PROPERTY_HINT_DIR,
					"hint_string": "The directory where the imported recipes are located.",
				},
				{
					"name": "FullImport",
					"default_value": true,
					"hint_string": "When enabled all existing processors and directory will be removed when importing.",
				}
			]
		_:
			return []


func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
	return true


func _get_priority() -> float:
	return 1.0


func _get_resource_type() -> String:
	return "Resource"


func _get_import_order() -> int:
	return 0


func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> int:
	var write_dir := options.get("WriteDirectory") as String
	var recipes_dir := options.get("RecipesDirectory") as String
	var ingredients_dir := options.get("IngredientsDirectory") as String
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(ingredients_dir)) == false:
		push_warning("Ingredients directory does not exist: '%s'" % ingredients_dir)
		return ERR_FILE_NOT_FOUND
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(recipes_dir)) == false:
		push_warning("Recipes directory does not exist: '%s'" % recipes_dir)
		return ERR_FILE_NOT_FOUND
	var recreate := options.get("FullImport", false) as bool
	var err = AutomationGameDataImporterUtils.make_write_directory(write_dir, recreate)
	if err != OK: 
		printerr("Failed to make write directory: '%s' (%d)" % [write_dir, err])
		return err
	var json := AutomationGameDataImporterUtils.read_json_file(source_file)
	if json.has("error"):
		if json.has("msg"): printerr(json["msg"])
		return json.get("error") as int
	for id in AutomationGameDataImporterUtils.get_all_ids(json):
		var data := AutomationGameDataImporterUtils.get_by_id(json, id)
		if not _is_valid_data(data): continue

		var entity := ProcessorData.new()
		for key in data.keys():
			if key == "recipes":
				entity.recipes = _parse_recipes(data.get(key), recipes_dir)
				continue
			if key == "storages":
				entity.input_storages = AutomationGameDataImporterUtils.parse_quantitatives(data.get(key, {}).get("inputs", []), ingredients_dir)
				entity.output_storages = AutomationGameDataImporterUtils.parse_quantitatives(data.get(key, {}).get("outputs", []), ingredients_dir)
				continue
				pass
			entity.set(key, data.get(key))
			pass
		err = ResourceSaver.save(entity, write_dir.path_join(entity.resource_name + ".tres"))
		if err != OK:
			printerr("Failed to save: " + entity.resource_name)
			return err
		pass
	return OK

#endregion EditorImportPlugin Implementation

#region Private Methods

## Check if the given data is valid.
func _is_valid_data(data: Dictionary) -> bool:
	return not \
		data.is_empty() and \
		data.has("id") and data.get("id") is String and \
		data.has("recipes") and data.get("recipes") is Array  and \
		data.has("storages") and data.get("storages") is Dictionary


## Parse recipes from the given data object. Recipes path is used to load the recipes
## dependencies for the processor.
func _parse_recipes(data: Array, recipes_path: String) -> Array[RecipeData]:
	var result: Array[RecipeData] = []
	for item in data:
		result.append(_get_recipe_by_id(item, recipes_path))
		pass
	return result


## Get recipe by id from the given recipes path.
func _get_recipe_by_id(id: String, recipes_path: String) -> RecipeData:
	var path := recipes_path.path_join(AutomationGameDataImporterUtils.id_to_resource_name(id) + ".tres")
	var resource := ResourceLoader.load(path, "Resource", ResourceLoader.CACHE_MODE_IGNORE)
	if not resource:
		printerr("Failed to load recipe: " + id)
		return null
	return resource as RecipeData

#endregion Private Methods
