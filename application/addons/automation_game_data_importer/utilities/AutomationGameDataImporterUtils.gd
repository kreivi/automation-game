# Automation Game
# Copyright (C) 2024 Severi Vidnäs
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

@tool
class_name AutomationGameDataImporterUtils extends RefCounted

const PROPERTY_NAME_ALL_IDS: String = "allIds"
const PROPERTY_NAME_BY_ID: String = "byId"

## Read JSON file from given path. Expects the JSON root to be object that is castable to Dictionary.
static func read_json_file(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return { "error": FileAccess.get_open_error() }
	var json := JSON.parse_string(file.get_as_text()) as Dictionary
	if json == null:
		return { "error": ERR_INVALID_DATA, "msg": "Unrecognized JSON format" }
	return json


## Remove directory and its contents from the given path.
static func remove_directory(res_path: String) -> int:
	var abs_path := ProjectSettings.globalize_path(res_path)
	if not DirAccess.dir_exists_absolute(abs_path): return OK
	var files := DirAccess.get_files_at(abs_path)
	for file in files:
		var err := DirAccess.remove_absolute(abs_path.path_join(file))
		if err != OK: return err
	return DirAccess.remove_absolute(abs_path)


## Create directory at the given path. Recreate will remove the directory and its contents if it already exists.
static func make_write_directory(res_path: String, recreate := false) -> int:
	var abs_path := ProjectSettings.globalize_path(res_path)
	if DirAccess.dir_exists_absolute(abs_path):
		if not recreate: return OK
		var err := AutomationGameDataImporterUtils.remove_directory(res_path)
		if err != OK: return err
	return DirAccess.make_dir_recursive_absolute(abs_path)


static func get_all_ids(data: Dictionary) -> Array:
	return data.get(PROPERTY_NAME_ALL_IDS, []) as Array


static func get_by_id_property(data: Dictionary) -> Dictionary:
	return data.get(PROPERTY_NAME_BY_ID, {}) as Dictionary


static func get_by_id(data: Dictionary, id: String) -> Dictionary:
	return get_by_id_property(data).get(id, {}) as Dictionary


## Consistent way to convert id to resource name.
static func id_to_resource_name(id: String) -> String:
	return id.capitalize().replace(" ", "")


## Parse the quantitative data objects from the given data array. Ingredients path is used to load the ingredients
## dependencies for the recipe.
static func parse_quantitatives(data: Array, ingredients_path: String) -> Array[QuantitativeData]:
	var result: Array[QuantitativeData] = []
	for item in data:
		var qd := QuantitativeData.new()
		for key in item.keys():
			if key == "id":
				qd.ingredient = AutomationGameDataImporterUtils.get_ingredient_by_id(item.get(key), ingredients_path)
				continue
			qd.set(key, item.get(key))
			pass
		result.append(qd)
		pass
	return result

## Get ingredient by id from the given ingredients path.
static func get_ingredient_by_id(id: String, ingredients_path: String) -> IngredientData:
	var path := ingredients_path.path_join(AutomationGameDataImporterUtils.id_to_resource_name(id) + ".tres")
	var resource := ResourceLoader.load(path, "Resource", ResourceLoader.CACHE_MODE_IGNORE)
	if not resource:
		printerr("Failed to load ingredient: " + id)
		return null
	return resource as IngredientData